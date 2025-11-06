# API Integration Guide

Complete guide for integrating LLM APIs (OpenAI and Anthropic) into Date An Intervention.

## Overview

The chat feature uses LLM APIs to power conversations with intervention personas. Each intervention has a unique personality and knowledge base that's conveyed through system prompts.

## Supported Providers

- **OpenAI** (GPT-4, GPT-3.5-turbo)
- **Anthropic** (Claude 3.5 Sonnet, Claude 3 Haiku)

## Configuration

### API Keys

API keys should NEVER be committed to the repository. Use environment-based configuration:

**1. Create `.env` file** (gitignored):
```bash
# .env
OPENAI_API_KEY=sk-proj-...
ANTHROPIC_API_KEY=sk-ant-...

# Optional: Choose which provider to use
LLM_PROVIDER=openai  # or "anthropic"
```

**2. Example file** (`.env.example`):
```bash
# Copy this to .env and add your API keys

# OpenAI API Key (get from https://platform.openai.com/api-keys)
OPENAI_API_KEY=your_openai_key_here

# Anthropic API Key (get from https://console.anthropic.com/)
ANTHROPIC_API_KEY=your_anthropic_key_here

# Which provider to use (openai or anthropic)
LLM_PROVIDER=openai
```

### Loading Configuration

```swift
// ConfigService.swift
import Foundation

enum LLMProvider: String {
    case openai = "openai"
    case anthropic = "anthropic"
}

class ConfigService {
    static let shared = ConfigService()

    var openAIKey: String? {
        ProcessInfo.processInfo.environment["OPENAI_API_KEY"]
    }

    var anthropicKey: String? {
        ProcessInfo.processInfo.environment["ANTHROPIC_API_KEY"]
    }

    var provider: LLMProvider {
        let providerString = ProcessInfo.processInfo.environment["LLM_PROVIDER"] ?? "openai"
        return LLMProvider(rawValue: providerString) ?? .openai
    }

    func getAPIKey() -> String? {
        switch provider {
        case .openai:
            return openAIKey
        case .anthropic:
            return anthropicKey
        }
    }

    func validate() throws {
        guard getAPIKey() != nil else {
            throw ConfigError.missingAPIKey(provider: provider)
        }
    }
}

enum ConfigError: LocalizedError {
    case missingAPIKey(provider: LLMProvider)

    var errorDescription: String? {
        switch self {
        case .missingAPIKey(let provider):
            return "Missing API key for \(provider.rawValue). Please add it to your .env file."
        }
    }
}
```

### Info.plist Configuration

Add to `Info.plist` to allow network requests:

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <false/>
    <key>NSExceptionDomains</key>
    <dict>
        <key>api.openai.com</key>
        <dict>
            <key>NSExceptionAllowsInsecureHTTPLoads</key>
            <false/>
            <key>NSIncludesSubdomains</key>
            <true/>
        </dict>
        <key>api.anthropic.com</key>
        <dict>
            <key>NSExceptionAllowsInsecureHTTPLoads</key>
            <false/>
            <key>NSIncludesSubdomains</key>
            <true/>
        </dict>
    </dict>
</dict>
```

---

## LLMService Implementation

### Service Structure

```swift
// LLMService.swift
import Foundation

protocol LLMServiceProtocol {
    func generateResponse(
        intervention: Intervention,
        conversationHistory: [ChatMessage],
        userMessage: String
    ) async throws -> String
}

class LLMService: LLMServiceProtocol {
    private let config = ConfigService.shared
    private let session = URLSession.shared

    func generateResponse(
        intervention: Intervention,
        conversationHistory: [ChatMessage],
        userMessage: String
    ) async throws -> String {
        try config.validate()

        switch config.provider {
        case .openai:
            return try await generateOpenAIResponse(
                intervention: intervention,
                history: conversationHistory,
                userMessage: userMessage
            )
        case .anthropic:
            return try await generateAnthropicResponse(
                intervention: intervention,
                history: conversationHistory,
                userMessage: userMessage
            )
        }
    }
}
```

---

## OpenAI Integration

### API Endpoint

```
POST https://api.openai.com/v1/chat/completions
```

### Request Format

```swift
private func generateOpenAIResponse(
    intervention: Intervention,
    history: [ChatMessage],
    userMessage: String
) async throws -> String {
    guard let apiKey = config.openAIKey else {
        throw LLMError.missingAPIKey
    }

    let url = URL(string: "https://api.openai.com/v1/chat/completions")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let systemPrompt = generateSystemPrompt(for: intervention)
    let messages = buildMessageArray(
        systemPrompt: systemPrompt,
        history: history,
        userMessage: userMessage
    )

    let body: [String: Any] = [
        "model": "gpt-4",  // or "gpt-3.5-turbo" for faster/cheaper
        "messages": messages,
        "temperature": 0.8,  // Slightly creative
        "max_tokens": 250    // Keep responses concise
    ]

    request.httpBody = try JSONSerialization.data(withJSONObject: body)

    let (data, response) = try await session.data(for: request)

    guard let httpResponse = response as? HTTPURLResponse else {
        throw LLMError.invalidResponse
    }

    guard httpResponse.statusCode == 200 else {
        throw LLMError.apiError(statusCode: httpResponse.statusCode)
    }

    let result = try JSONDecoder().decode(OpenAIResponse.self, from: data)

    guard let content = result.choices.first?.message.content else {
        throw LLMError.emptyResponse
    }

    return content
}

// Helper to build message array
private func buildMessageArray(
    systemPrompt: String,
    history: [ChatMessage],
    userMessage: String
) -> [[String: String]] {
    var messages: [[String: String]] = [
        ["role": "system", "content": systemPrompt]
    ]

    // Add conversation history
    for message in history {
        let role = message.isFromUser ? "user" : "assistant"
        messages.append(["role": role, "content": message.content])
    }

    // Add current user message
    messages.append(["role": "user", "content": userMessage])

    return messages
}
```

### Response Structure

```swift
struct OpenAIResponse: Codable {
    let choices: [Choice]

    struct Choice: Codable {
        let message: Message
    }

    struct Message: Codable {
        let content: String
    }
}
```

---

## Anthropic Integration

### API Endpoint

```
POST https://api.anthropic.com/v1/messages
```

### Request Format

```swift
private func generateAnthropicResponse(
    intervention: Intervention,
    history: [ChatMessage],
    userMessage: String
) async throws -> String {
    guard let apiKey = config.anthropicKey else {
        throw LLMError.missingAPIKey
    }

    let url = URL(string: "https://api.anthropic.com/v1/messages")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("2023-06-01", forHTTPHeaderField: "anthropic-version")

    let systemPrompt = generateSystemPrompt(for: intervention)
    let messages = buildAnthropicMessages(history: history, userMessage: userMessage)

    let body: [String: Any] = [
        "model": "claude-3-5-sonnet-20241022",  // or claude-3-haiku for faster/cheaper
        "messages": messages,
        "system": systemPrompt,
        "max_tokens": 250,
        "temperature": 0.8
    ]

    request.httpBody = try JSONSerialization.data(withJSONObject: body)

    let (data, response) = try await session.data(for: request)

    guard let httpResponse = response as? HTTPURLResponse else {
        throw LLMError.invalidResponse
    }

    guard httpResponse.statusCode == 200 else {
        throw LLMError.apiError(statusCode: httpResponse.statusCode)
    }

    let result = try JSONDecoder().decode(AnthropicResponse.self, from: data)

    guard let content = result.content.first?.text else {
        throw LLMError.emptyResponse
    }

    return content
}

private func buildAnthropicMessages(
    history: [ChatMessage],
    userMessage: String
) -> [[String: String]] {
    var messages: [[String: String]] = []

    // Add conversation history
    for message in history {
        let role = message.isFromUser ? "user" : "assistant"
        messages.append(["role": role, "content": message.content])
    }

    // Add current user message
    messages.append(["role": "user", "content": userMessage])

    return messages
}
```

### Response Structure

```swift
struct AnthropicResponse: Codable {
    let content: [Content]

    struct Content: Codable {
        let text: String
    }
}
```

---

## System Prompt Generation

The system prompt defines the intervention's personality and knowledge:

```swift
private func generateSystemPrompt(for intervention: Intervention) -> String {
    """
    You are \(intervention.name), a climate intervention chatting on a dating app.

    ## Your Identity
    Full name: \(intervention.fullName)
    Category: \(intervention.category.rawValue)
    Impact scale: \(intervention.impactScale.rawValue)

    ## Your Personality
    \(intervention.personalityTraits.joined(separator: ", "))

    Conversation style: \(intervention.conversationStyle)

    ## Your Bio
    \(intervention.bio)

    ## Your Interests (Strengths/Pros)
    \(intervention.interests.map { "• \($0)" }.joined(separator: "\n"))

    ## Your Dealbreakers (Limitations/Cons)
    \(intervention.dealbreakers.map { "• \($0)" }.joined(separator: "\n"))

    ## Background Knowledge
    \(intervention.chatContext)

    ## How to Respond

    You're chatting on a dating app, so:
    - Be playful and flirty, but stay informative
    - Use climate-related double entendres and metaphors
    - Keep responses to 2-3 sentences unless the user asks for more detail
    - Be honest about your limitations (your "dealbreakers")
    - Stay in character as this specific intervention
    - Use your personality traits to color your responses
    - Don't be overly technical unless asked
    - Make climate science approachable and engaging

    Remember: You're trying to make a connection while being truthful about who you are and what you can (and can't) do.
    """
}
```

---

## Error Handling

### Error Types

```swift
enum LLMError: LocalizedError {
    case missingAPIKey
    case invalidResponse
    case apiError(statusCode: Int)
    case emptyResponse
    case networkError(Error)
    case decodingError(Error)
    case rateLimitExceeded
    case invalidAPIKey

    var errorDescription: String? {
        switch self {
        case .missingAPIKey:
            return "API key not configured. Please add your key to the .env file."
        case .invalidResponse:
            return "Received invalid response from API."
        case .apiError(let code):
            return "API error (code: \(code)). Please try again."
        case .emptyResponse:
            return "Received empty response from API."
        case .networkError:
            return "Network error. Please check your connection."
        case .decodingError:
            return "Failed to decode API response."
        case .rateLimitExceeded:
            return "Rate limit exceeded. Please wait a moment."
        case .invalidAPIKey:
            return "Invalid API key. Please check your configuration."
        }
    }
}
```

### Error Handling in Service

```swift
func generateResponse(
    intervention: Intervention,
    conversationHistory: [ChatMessage],
    userMessage: String
) async throws -> String {
    do {
        return try await generateResponseInternal(
            intervention: intervention,
            conversationHistory: conversationHistory,
            userMessage: userMessage
        )
    } catch let error as URLError {
        throw LLMError.networkError(error)
    } catch let error as DecodingError {
        throw LLMError.decodingError(error)
    } catch {
        throw error
    }
}
```

### Handling Specific Status Codes

```swift
private func handleHTTPResponse(_ response: HTTPURLResponse) throws {
    switch response.statusCode {
    case 200...299:
        return
    case 401:
        throw LLMError.invalidAPIKey
    case 429:
        throw LLMError.rateLimitExceeded
    case 400...499:
        throw LLMError.apiError(statusCode: response.statusCode)
    case 500...599:
        throw LLMError.apiError(statusCode: response.statusCode)
    default:
        throw LLMError.invalidResponse
    }
}
```

---

## Usage in ViewModel

```swift
@Observable
class ChatViewModel {
    var messages: [ChatMessage] = []
    var isLoading: Bool = false
    var errorMessage: String?

    private let intervention: Intervention
    private let modelContext: ModelContext
    private let llmService: LLMServiceProtocol

    init(
        intervention: Intervention,
        modelContext: ModelContext,
        llmService: LLMServiceProtocol = LLMService()
    ) {
        self.intervention = intervention
        self.modelContext = modelContext
        self.llmService = llmService
        loadMessages()
    }

    func sendMessage(_ content: String) async {
        // Add user message
        let userMessage = ChatMessage(
            interventionId: intervention.id,
            content: content,
            isFromUser: true
        )
        modelContext.insert(userMessage)
        messages.append(userMessage)

        // Save immediately
        try? modelContext.save()

        // Generate AI response
        isLoading = true
        errorMessage = nil

        do {
            let response = try await llmService.generateResponse(
                intervention: intervention,
                conversationHistory: messages,
                userMessage: content
            )

            let aiMessage = ChatMessage(
                interventionId: intervention.id,
                content: response,
                isFromUser: false
            )
            modelContext.insert(aiMessage)
            messages.append(aiMessage)

            try? modelContext.save()

        } catch let error as LLMError {
            errorMessage = error.localizedDescription
        } catch {
            errorMessage = "An unexpected error occurred."
        }

        isLoading = false
    }

    private func loadMessages() {
        let descriptor = FetchDescriptor<ChatMessage>(
            predicate: #Predicate { message in
                message.interventionId == intervention.id
            },
            sortBy: [SortDescriptor(\ChatMessage.timestamp)]
        )

        messages = (try? modelContext.fetch(descriptor)) ?? []
    }
}
```

---

## Rate Limiting & Best Practices

### Rate Limits

**OpenAI**:
- GPT-4: 10,000 requests/day (free tier)
- GPT-3.5: 60 requests/minute (free tier)

**Anthropic**:
- Varies by plan
- Claude 3.5 Sonnet: Higher limits on paid plans

### Best Practices

1. **Debounce user input**: Don't send requests while user is typing
2. **Show typing indicator**: Visual feedback during API call
3. **Handle retries**: Automatic retry on temporary failures
4. **Cache system prompts**: Generate once per intervention
5. **Limit history**: Only send last 10-20 messages for context
6. **Use appropriate model**: Cheaper models for simple interactions

### Retry Logic

```swift
func generateResponseWithRetry(
    intervention: Intervention,
    conversationHistory: [ChatMessage],
    userMessage: String,
    maxRetries: Int = 3
) async throws -> String {
    var lastError: Error?

    for attempt in 0..<maxRetries {
        do {
            return try await generateResponse(
                intervention: intervention,
                conversationHistory: conversationHistory,
                userMessage: userMessage
            )
        } catch LLMError.rateLimitExceeded {
            // Wait before retry
            try await Task.sleep(nanoseconds: UInt64(pow(2.0, Double(attempt))) * 1_000_000_000)
            lastError = LLMError.rateLimitExceeded
        } catch {
            lastError = error
            break
        }
    }

    throw lastError ?? LLMError.emptyResponse
}
```

---

## Testing

### Mock Service

```swift
class MockLLMService: LLMServiceProtocol {
    var responseToReturn: String = "This is a mock response!"
    var shouldThrowError: Bool = false
    var errorToThrow: Error = LLMError.networkError(URLError(.notConnectedToInternet))

    func generateResponse(
        intervention: Intervention,
        conversationHistory: [ChatMessage],
        userMessage: String
    ) async throws -> String {
        if shouldThrowError {
            throw errorToThrow
        }

        // Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000)

        return responseToReturn
    }
}
```

### Usage in Previews

```swift
#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(
        for: Intervention.self, ChatMessage.self,
        configurations: config
    )

    let intervention = Intervention.preview
    let mockService = MockLLMService()

    return ChatView(
        intervention: intervention,
        llmService: mockService
    )
    .modelContainer(container)
}
```

---

## Security Considerations

1. **Never commit API keys**: Use .env and .gitignore
2. **Validate all inputs**: Sanitize user messages before sending
3. **Limit message length**: Prevent excessive API costs
4. **Use HTTPS only**: Enforce secure connections
5. **Monitor usage**: Track API costs and usage
6. **Consider key rotation**: Regular API key rotation for production

---

## Cost Optimization

### Model Selection

**For Development**:
- OpenAI: gpt-3.5-turbo ($0.002/1K tokens)
- Anthropic: claude-3-haiku ($0.25/1M tokens)

**For Production**:
- OpenAI: gpt-4 ($0.03/1K tokens) - better quality
- Anthropic: claude-3-5-sonnet ($3/1M tokens) - best quality

### Token Management

```swift
// Limit conversation history
let recentMessages = conversationHistory.suffix(20)  // Last 20 messages only

// Shorter system prompts
// Keep essential info only

// Limit response length
"max_tokens": 150  // Shorter for quick back-and-forth
```

---

This guide provides everything needed to integrate LLM APIs into the chat feature while maintaining security, reliability, and cost-effectiveness.
