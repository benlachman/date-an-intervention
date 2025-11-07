//
//  LLMService.swift
//  DateAnIntervention
//
//  Multi-provider LLM service supporting OpenAI and Anthropic
//

import Foundation

// MARK: - LLM Error Types

enum LLMError: LocalizedError {
    case invalidAPIKey
    case networkError(Error)
    case invalidResponse
    case apiError(String)
    case unsupportedProvider

    var errorDescription: String? {
        switch self {
        case .invalidAPIKey:
            return "Invalid or missing API key"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid response from API"
        case .apiError(let message):
            return "API error: \(message)"
        case .unsupportedProvider:
            return "Unsupported LLM provider"
        }
    }
}

// MARK: - LLM Service Protocol

protocol LLMServiceProtocol {
    func sendMessage(
        systemPrompt: String,
        conversationHistory: [ChatMessage],
        userMessage: String
    ) async throws -> String
}

// MARK: - LLM Service Implementation

class LLMService: LLMServiceProtocol {

    private let provider: Config.LLMProvider
    private let apiKey: String
    private let model: String
    private let temperature: Double
    private let maxTokens: Int

    init(
        provider: Config.LLMProvider? = nil,
        apiKey: String? = nil,
        model: String? = nil,
        temperature: Double? = nil,
        maxTokens: Int? = nil
    ) {
        self.provider = provider ?? Config.llmProvider
        self.temperature = temperature ?? Config.llmTemperature
        self.maxTokens = maxTokens ?? Config.llmMaxTokens

        // Set API key and model based on provider
        switch self.provider {
        case .openai:
            self.apiKey = apiKey ?? Config.openAIAPIKey
            self.model = model ?? Config.llmModel ?? "gpt-4o"
        case .anthropic:
            self.apiKey = apiKey ?? Config.anthropicAPIKey
            self.model = model ?? Config.llmModel ?? "claude-3-5-sonnet-20241022"
        }
    }

    // MARK: - Public API

    func sendMessage(
        systemPrompt: String,
        conversationHistory: [ChatMessage],
        userMessage: String
    ) async throws -> String {
        switch provider {
        case .openai:
            return try await sendOpenAIMessage(
                systemPrompt: systemPrompt,
                conversationHistory: conversationHistory,
                userMessage: userMessage
            )
        case .anthropic:
            return try await sendAnthropicMessage(
                systemPrompt: systemPrompt,
                conversationHistory: conversationHistory,
                userMessage: userMessage
            )
        }
    }

    // MARK: - OpenAI Implementation

    private func sendOpenAIMessage(
        systemPrompt: String,
        conversationHistory: [ChatMessage],
        userMessage: String
    ) async throws -> String {
        guard !apiKey.isEmpty, !apiKey.contains("YOUR_") else {
            throw LLMError.invalidAPIKey
        }

        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        // Enhance system prompt for ultra-brief, human-like responses
        let enhancedPrompt = """
        \(systemPrompt)

        CRITICAL INSTRUCTIONS:
        - Keep responses EXTREMELY short (1-2 sentences MAX, often just 1)
        - Sound like texting a crush on Tinder - casual, playful, natural
        - Use lowercase sometimes, contractions, casual language
        - Be flirty but conversational - like a real human would text
        - NO formal language, NO essay-style responses
        - Think: "how would I text this?" not "how would I write this?"
        - Brief, punchy, fun - this is casual texting, not a presentation
        - Use emojis VERY sparingly - maybe 1 in every 5-6 messages, not every message
        """

        // Build messages array
        var messages: [[String: String]] = [
            ["role": "system", "content": enhancedPrompt]
        ]

        // Add conversation history
        for message in conversationHistory {
            messages.append([
                "role": message.isFromUser ? "user" : "assistant",
                "content": message.content
            ])
        }

        // Add new user message
        messages.append([
            "role": "user",
            "content": userMessage
        ])

        let requestBody: [String: Any] = [
            "model": model,
            "messages": messages,
            "temperature": temperature,
            "max_tokens": maxTokens
        ]

        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw LLMError.invalidResponse
            }

            guard httpResponse.statusCode == 200 else {
                if let errorJson = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let error = errorJson["error"] as? [String: Any],
                   let message = error["message"] as? String {
                    throw LLMError.apiError(message)
                }
                throw LLMError.apiError("HTTP \(httpResponse.statusCode)")
            }

            guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let choices = json["choices"] as? [[String: Any]],
                  let firstChoice = choices.first,
                  let message = firstChoice["message"] as? [String: Any],
                  let content = message["content"] as? String else {
                throw LLMError.invalidResponse
            }

            return content

        } catch let error as LLMError {
            throw error
        } catch {
            throw LLMError.networkError(error)
        }
    }

    // MARK: - Anthropic Implementation

    private func sendAnthropicMessage(
        systemPrompt: String,
        conversationHistory: [ChatMessage],
        userMessage: String
    ) async throws -> String {
        guard !apiKey.isEmpty, !apiKey.contains("YOUR_") else {
            throw LLMError.invalidAPIKey
        }

        let url = URL(string: "https://api.anthropic.com/v1/messages")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.setValue("2023-06-01", forHTTPHeaderField: "anthropic-version")

        // Enhance system prompt for ultra-brief, human-like responses
        let enhancedPrompt = """
        \(systemPrompt)

        CRITICAL INSTRUCTIONS:
        - Keep responses EXTREMELY short (1-2 sentences MAX, often just 1)
        - Sound like texting a crush on Tinder - casual, playful, natural
        - Use lowercase sometimes, contractions, casual language
        - Be flirty but conversational - like a real human would text
        - NO formal language, NO essay-style responses
        - Think: "how would I text this?" not "how would I write this?"
        - Brief, punchy, fun - this is casual texting, not a presentation
        - Use emojis VERY sparingly - maybe 1 in every 5-6 messages, not every message
        """

        // Build messages array for Anthropic format
        var messages: [[String: Any]] = []

        // Add conversation history
        for message in conversationHistory {
            messages.append([
                "role": message.isFromUser ? "user" : "assistant",
                "content": message.content
            ])
        }

        // Add new user message
        messages.append([
            "role": "user",
            "content": userMessage
        ])

        let requestBody: [String: Any] = [
            "model": model,
            "max_tokens": maxTokens,
            "temperature": temperature,
            "system": enhancedPrompt,
            "messages": messages
        ]

        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw LLMError.invalidResponse
            }

            guard httpResponse.statusCode == 200 else {
                if let errorJson = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let error = errorJson["error"] as? [String: Any],
                   let message = error["message"] as? String {
                    throw LLMError.apiError(message)
                }
                throw LLMError.apiError("HTTP \(httpResponse.statusCode)")
            }

            guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let content = json["content"] as? [[String: Any]],
                  let firstContent = content.first,
                  let text = firstContent["text"] as? String else {
                throw LLMError.invalidResponse
            }

            return text

        } catch let error as LLMError {
            throw error
        } catch {
            throw LLMError.networkError(error)
        }
    }
}
