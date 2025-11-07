//
//  MessageBubbleView.swift
//  DateAnIntervention
//
//  Message bubble component for chat interface
//

import SwiftUI

struct MessageBubbleView: View {

    let message: ChatMessage
    let interventionColors: [Color]

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if message.isFromUser {
                Spacer()
            }

            VStack(alignment: message.isFromUser ? .trailing : .leading, spacing: 4) {
                Text(message.content)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(bubbleBackground)
                    .foregroundStyle(message.isFromUser ? .white : .primary)
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                Text(formatTime(message.timestamp))
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 4)
            }

            if !message.isFromUser {
                Spacer()
            }
        }
        .padding(.horizontal)
    }

    // MARK: - Bubble Background

    @ViewBuilder
    private var bubbleBackground: some View {
        if message.isFromUser {
            // User messages: solid blue
            Color.blue
        } else {
            // AI messages: intervention gradient
            if interventionColors.count >= 2 {
                LinearGradient(
                    colors: interventionColors,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .opacity(0.15)
            } else {
                Color.gray.opacity(0.15)
            }
        }
    }

    // MARK: - Time Formatting

    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        let calendar = Calendar.current

        if calendar.isDateInToday(date) {
            formatter.dateFormat = "h:mm a"
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            formatter.dateFormat = "MMM d"
        }

        return formatter.string(from: date)
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 16) {
        MessageBubbleView(
            message: ChatMessage(
                content: "Hey there! I'm Marine Cloud Brightening. Want to hear about how I can help cool the planet?",
                isFromUser: false
            ),
            interventionColors: [.blue, .cyan]
        )

        MessageBubbleView(
            message: ChatMessage(
                content: "That sounds interesting! Tell me more.",
                isFromUser: true
            ),
            interventionColors: [.blue, .cyan]
        )
    }
    .padding()
}
