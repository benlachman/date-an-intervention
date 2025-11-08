//
//  Config.swift
//  DateAnIntervention
//
//  Configuration management for API keys
//

import Foundation

struct Config {

    // MARK: - API Keys

    /// OpenAI API Key
    /// Priority: Environment Variable > Config.plist > Placeholder
    /// For Xcode Cloud: Set OPENAI_API_KEY in App Store Connect environment variables
    /// For local dev: Set in Config.plist
    static var openAIAPIKey: String {
        if let key = getConfigValue(for: "OPENAI_API_KEY"), !key.isEmpty {
            return key
        }
        return "YOUR_OPENAI_API_KEY" // Default placeholder
    }

    /// Anthropic API Key
    /// Priority: Environment Variable > Config.plist > Placeholder
    /// For Xcode Cloud: Set ANTHROPIC_API_KEY in App Store Connect environment variables
    /// For local dev: Set in Config.plist
    static var anthropicAPIKey: String {
        if let key = getConfigValue(for: "ANTHROPIC_API_KEY"), !key.isEmpty {
            return key
        }
        return "YOUR_ANTHROPIC_API_KEY" // Default placeholder
    }

    // MARK: - LLM Configuration

    enum LLMProvider: String {
        case openai = "openai"
        case anthropic = "anthropic"
    }

    /// Which LLM provider to use
    static var llmProvider: LLMProvider {
        if let provider = getConfigValue(for: "LLM_PROVIDER"),
           let llmProvider = LLMProvider(rawValue: provider.lowercased()) {
            return llmProvider
        }
        return .openai // Default to OpenAI
    }

    /// Model name to use (optional, uses provider defaults if not set)
    static var llmModel: String? {
        getConfigValue(for: "LLM_MODEL")
    }

    /// Temperature for LLM responses (0.0 - 1.0)
    static var llmTemperature: Double {
        if let temp = getConfigValue(for: "LLM_TEMPERATURE"),
           let value = Double(temp) {
            return value
        }
        return 0.8 // Default temperature
    }

    /// Maximum tokens for LLM responses
    static var llmMaxTokens: Int {
        if let tokens = getConfigValue(for: "LLM_MAX_TOKENS"),
           let value = Int(tokens) {
            return value
        }
        return 250 // Default max tokens
    }

    // MARK: - Private Helpers

    /// Reads a value from environment variables, Config.plist, or Info.plist
    /// Priority: Environment Variables > Config.plist > Info.plist
    /// This allows Xcode Cloud to use environment variables while local dev uses Config.plist
    private static func getConfigValue(for key: String) -> String? {
        // 1. First check environment variables (for Xcode Cloud / CI)
        if let envValue = ProcessInfo.processInfo.environment[key], !envValue.isEmpty {
            return envValue
        }

        // 2. Then try to load from Config.plist (for local development)
        if let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
           let config = NSDictionary(contentsOfFile: path),
           let value = config[key] as? String, !value.isEmpty {
            return value
        }

        // 3. Fall back to Info.plist (optional fallback)
        if let value = Bundle.main.object(forInfoDictionaryKey: key) as? String, !value.isEmpty {
            return value
        }

        return nil
    }
}
