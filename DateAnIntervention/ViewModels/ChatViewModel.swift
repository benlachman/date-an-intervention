//
//  ChatViewModel.swift
//  DateAnIntervention
//
//  Manages chat state and LLM interactions
//

import Foundation
import SwiftData

@Observable
class ChatViewModel {

    // MARK: - Properties

    var messages: [ChatMessage] = []
    var isLoading: Bool = false
    var errorMessage: String?
    var intervention: Intervention

    private let llmService: LLMServiceProtocol
    private let modelContext: ModelContext

    // MARK: - Initialization

    init(intervention: Intervention, modelContext: ModelContext, llmService: LLMServiceProtocol? = nil) {
        self.intervention = intervention
        self.modelContext = modelContext
        self.llmService = llmService ?? LLMService()

        // Load existing messages for this intervention
        loadMessages()

        // If no messages exist, send the opening line
        if messages.isEmpty {
            sendOpeningMessage()
        }
    }

    // MARK: - Public Methods

    /// Send a user message and get AI response
    func sendMessage(_ content: String) async {
        guard !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }

        // Create and save user message
        let userMessage = ChatMessage(
            content: content,
            isFromUser: true,
            intervention: intervention
        )

        await MainActor.run {
            messages.append(userMessage)
            isLoading = true
            errorMessage = nil
        }

        modelContext.insert(userMessage)
        try? modelContext.save()

        // Get AI response
        do {
            let response = try await llmService.sendMessage(
                systemPrompt: intervention.systemPrompt,
                conversationHistory: messages.filter { $0 != userMessage },
                userMessage: content
            )

            // Create and save AI message
            let aiMessage = ChatMessage(
                content: response,
                isFromUser: false,
                intervention: intervention
            )

            await MainActor.run {
                messages.append(aiMessage)
                isLoading = false
            }

            modelContext.insert(aiMessage)
            try? modelContext.save()

            // Success haptic
            HapticService.success()

        } catch {
            await MainActor.run {
                isLoading = false
                errorMessage = error.localizedDescription
            }

            // Error haptic
            HapticService.error()
        }
    }

    /// Clear all messages for this conversation
    func clearMessages() {
        // Delete all messages from database
        for message in messages {
            modelContext.delete(message)
        }

        try? modelContext.save()

        // Clear local array
        messages.removeAll()

        // Send opening message again
        sendOpeningMessage()

        HapticService.mediumImpact()
    }

    // MARK: - Private Methods

    /// Load messages from database
    private func loadMessages() {
        let interventionId = intervention.id
        let descriptor = FetchDescriptor<ChatMessage>(
            predicate: #Predicate { message in
                message.intervention?.id == interventionId
            },
            sortBy: [SortDescriptor(\.timestamp, order: .forward)]
        )

        do {
            messages = try modelContext.fetch(descriptor)
        } catch {
            print("Failed to load messages: \(error)")
            messages = []
        }
    }

    /// Send the intervention's opening line as first message
    private func sendOpeningMessage() {
        let openingMessage = ChatMessage(
            content: intervention.openingLine,
            isFromUser: false,
            intervention: intervention
        )

        messages.append(openingMessage)
        modelContext.insert(openingMessage)
        try? modelContext.save()
    }
}
