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
    /// Set this in Config.plist or use the default placeholder
    static var openAIAPIKey: String {
        if let key = getConfigValue(for: "OPENAI_API_KEY"), !key.isEmpty {
            return key
        }
        return "YOUR_OPENAI_API_KEY" // Default placeholder
    }

    /// Anthropic API Key
    /// Set this in Config.plist or use the default placeholder
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

    /// Reads a value from Config.plist
    private static func getConfigValue(for key: String) -> String? {
        // First try to load from Config.plist
        if let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
           let config = NSDictionary(contentsOfFile: path),
           let value = config[key] as? String {
            return value
        }

        // Fall back to Info.plist
        if let value = Bundle.main.object(forInfoDictionaryKey: key) as? String {
            return value
        }

        return nil
    }
}
