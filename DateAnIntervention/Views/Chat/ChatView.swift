//
//  ChatView.swift
//  DateAnIntervention
//
//  Chat interface for messaging with interventions
//

import SwiftUI
import SwiftData

struct ChatView: View {

    // MARK: - Properties

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    let intervention: Intervention

    @State private var viewModel: ChatViewModel?
    @State private var messageText: String = ""
    @State private var showClearConfirmation: Bool = false

    @FocusState private var isInputFocused: Bool

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            // Chat Header
            headerView

            Divider()

            // Messages List
            if let viewModel = viewModel {
                messagesListView(viewModel: viewModel)
            } else {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }

            // Error Message
            if let viewModel = viewModel, let errorMessage = viewModel.errorMessage {
                errorBanner(message: errorMessage)
            }

            Divider()

            // Input Area
            inputView
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if viewModel == nil {
                viewModel = ChatViewModel(intervention: intervention, modelContext: modelContext)
            }
        }
    }

    // MARK: - Header View

    private var headerView: some View {
        HStack(spacing: 12) {
            // Back Button
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.title3)
                    .foregroundStyle(.primary)
            }

            // Intervention Info
            VStack(alignment: .leading, spacing: 2) {
                Text(intervention.name)
                    .font(.headline)
                    .lineLimit(1)

                Text(intervention.category.displayName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            // Clear Chat Button
            Menu {
                Button(role: .destructive, action: { showClearConfirmation = true }) {
                    Label("Clear Chat", systemImage: "trash")
                }
            } label: {
                Image(systemName: "ellipsis.circle")
                    .font(.title3)
                    .foregroundStyle(.primary)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .confirmationDialog(
            "Clear Chat",
            isPresented: $showClearConfirmation,
            titleVisibility: .visible
        ) {
            Button("Clear All Messages", role: .destructive) {
                viewModel?.clearMessages()
            }
        } message: {
            Text("This will delete all messages in this conversation.")
        }
    }

    // MARK: - Messages List View

    private func messagesListView(viewModel: ChatViewModel) -> some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.messages) { message in
                        MessageBubbleView(
                            message: message,
                            interventionColors: interventionGradientColors
                        )
                        .id(message.id)
                    }

                    // Loading Indicator
                    if viewModel.isLoading {
                        HStack {
                            ProgressView()
                                .padding(.horizontal)
                            Spacer()
                        }
                    }
                }
                .padding(.vertical)
            }
            .onChange(of: viewModel.messages.count) { _, _ in
                // Scroll to bottom when new message arrives
                if let lastMessage = viewModel.messages.last {
                    withAnimation {
                        proxy.scrollTo(lastMessage.id, anchor: .bottom)
                    }
                }
            }
            .onAppear {
                // Scroll to bottom on appear
                if let lastMessage = viewModel.messages.last {
                    proxy.scrollTo(lastMessage.id, anchor: .bottom)
                }
            }
        }
    }

    // MARK: - Error Banner

    private func errorBanner(message: String) -> some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(.orange)

            Text(message)
                .font(.caption)
                .foregroundStyle(.secondary)

            Spacer()

            Button(action: { viewModel?.errorMessage = nil }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color.orange.opacity(0.1))
    }

    // MARK: - Input View

    private var inputView: some View {
        HStack(spacing: 12) {
            TextField("Message \(intervention.name)...", text: $messageText, axis: .vertical)
                .textFieldStyle(.plain)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .lineLimit(1...5)
                .focused($isInputFocused)
                .onSubmit {
                    sendMessage()
                }

            Button(action: sendMessage) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.title2)
                    .foregroundStyle(
                        messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                            ? .gray : .blue
                    )
            }
            .disabled(
                messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                || viewModel?.isLoading == true
            )
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
    }

    // MARK: - Actions

    private func sendMessage() {
        guard let viewModel = viewModel,
              !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }

        let message = messageText
        messageText = ""
        isInputFocused = false

        Task {
            await viewModel.sendMessage(message)
        }

        // Light haptic feedback
        HapticService.lightImpact()
    }

    // MARK: - Helpers

    private var interventionGradientColors: [Color] {
        intervention.gradientColors.compactMap { hex in
            Color(hex: hex)
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        ChatView(
            intervention: Intervention(
                name: "Marine Cloud Brightening",
                category: .openSystems,
                bio: "Test bio",
                pros: ["Pro 1"],
                cons: ["Con 1"],
                sfSymbol: "cloud.fill",
                gradientColors: ["4A90E2", "7FDBFF"],
                researchLevel: 6,
                techReadiness: 5,
                publicSupport: 4,
                flirtStyle: "Friendly and informative",
                openingLine: "Hey there! Ready to talk about ocean science?",
                systemPrompt: "You are Marine Cloud Brightening, a climate intervention."
            )
        )
    }
    .modelContainer(for: [Intervention.self, ChatMessage.self, SwipeDecision.self])
}
