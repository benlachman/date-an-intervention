//
//  CardStackView.swift
//  DateAnIntervention
//
//  Created by Claude on 2025-11-06.
//

import SwiftUI
import SwiftData

struct CardStackView: View {
    @Bindable var viewModel: SwipeViewModel

    // Drag state
    @State private var dragOffset: CGSize = .zero
    @State private var dragRotation: Double = 0
    @State private var hasReachedThreshold = false

    // Profile detail state
    @State private var selectedIntervention: Intervention?

    // Constants
    private let swipeThreshold: CGFloat = 100
    private let rotationMultiplier: Double = 0.15
    private let maxCardsInStack = 3

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Show up to 3 cards in the stack
                ForEach(Array(visibleCards().enumerated()), id: \.element.id) { index, intervention in
                    InterventionCardView(intervention: intervention)
                        .frame(
                            width: cardWidth(for: geometry),
                            height: cardHeight(for: geometry)
                        )
                        .offset(y: CGFloat(index) * 8)
                        .scaleEffect(1.0 - (CGFloat(index) * 0.05))
                        .opacity(1.0 - (Double(index) * 0.2))
                        .zIndex(Double(visibleCards().count - index))
                        .overlay(alignment: .top) {
                            // Show like/dislike indicators only on top card
                            if index == 0 {
                                swipeIndicators
                            }
                        }
                        // Apply drag gesture only to top card
                        .offset(index == 0 ? dragOffset : .zero)
                        .rotationEffect(.degrees(index == 0 ? dragRotation : 0))
                        .onTapGesture {
                            if index == 0 {
                                selectedIntervention = intervention
                            }
                        }
                        .gesture(
                            index == 0 ? createDragGesture() : nil
                        )
                }

                // Empty state
                if viewModel.isEmpty {
                    emptyStateView
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .sheet(item: $selectedIntervention) { intervention in
            ProfileDetailView(intervention: intervention)
        }
    }

    // MARK: - Subviews

    private var swipeIndicators: some View {
        HStack {
            // NOPE indicator (left swipe)
            Text("NOPE")
                .font(.title)
                .fontWeight(.black)
                .foregroundStyle(.red)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.red, lineWidth: 5)
                )
                .rotationEffect(.degrees(-15))
                .opacity(dragOffset.width < 0 ? min(abs(dragOffset.width) / swipeThreshold, 1.0) : 0)
                .padding(.leading, 40)

            Spacer()

            // LIKE indicator (right swipe)
            Text("LIKE")
                .font(.title)
                .fontWeight(.black)
                .foregroundStyle(.green)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.green, lineWidth: 5)
                )
                .rotationEffect(.degrees(15))
                .opacity(dragOffset.width > 0 ? min(dragOffset.width / swipeThreshold, 1.0) : 0)
                .padding(.trailing, 40)
        }
        .padding(.top, 40)
    }

    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(.green)

            Text("You've Reviewed All Interventions!")
                .font(.title2)
                .fontWeight(.bold)

            Text("Check out your matches or reset to swipe again.")
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button("Reset Deck") {
                viewModel.reset()
            }
            .buttonStyle(.borderedProminent)
            .tint(.pink)
        }
        .padding()
    }

    // MARK: - Gestures

    private func createDragGesture() -> some Gesture {
        DragGesture()
            .onChanged { value in
                dragOffset = value.translation
                dragRotation = Double(value.translation.width) * rotationMultiplier

                // Check if threshold is reached for haptic feedback
                let currentlyPastThreshold = abs(value.translation.width) > swipeThreshold
                if currentlyPastThreshold && !hasReachedThreshold {
                    HapticService.lightImpact()
                    hasReachedThreshold = true
                } else if !currentlyPastThreshold {
                    hasReachedThreshold = false
                }
            }
            .onEnded { value in
                let swipeDistance = value.translation.width

                if abs(swipeDistance) > swipeThreshold {
                    // Complete the swipe
                    completeSwipe(direction: swipeDistance > 0 ? .right : .left)
                } else {
                    // Snap back
                    snapBack()
                }
            }
    }

    private func completeSwipe(direction: SwipeDirection) {
        guard let currentIntervention = viewModel.currentIntervention else { return }

        // Animate card off screen
        let screenWidth = UIScreen.main.bounds.width
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            dragOffset = CGSize(
                width: direction == .right ? screenWidth * 1.5 : -screenWidth * 1.5,
                height: 0
            )
            dragRotation = direction == .right ? 30 : -30
        }

        // Haptic feedback
        if direction == .right {
            HapticService.success()
        } else {
            HapticService.mediumImpact()
        }

        // Save decision and reset after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if direction == .right {
                viewModel.swipeRight(on: currentIntervention)
            } else {
                viewModel.swipeLeft(on: currentIntervention)
            }

            // Reset drag state
            dragOffset = .zero
            dragRotation = 0
            hasReachedThreshold = false
        }
    }

    private func snapBack() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            dragOffset = .zero
            dragRotation = 0
        }
        hasReachedThreshold = false
    }

    // MARK: - Helpers

    private func visibleCards() -> [Intervention] {
        let startIndex = viewModel.currentIndex
        let endIndex = min(startIndex + maxCardsInStack, viewModel.interventions.count)
        return Array(viewModel.interventions[startIndex..<endIndex])
    }

    private func cardWidth(for geometry: GeometryProxy) -> CGFloat {
        min(geometry.size.width * 0.88, 380)
    }

    private func cardHeight(for geometry: GeometryProxy) -> CGFloat {
        min(geometry.size.height * 0.80, 700)
    }
}

enum SwipeDirection {
    case left, right
}

#Preview {
    CardStackView(
        viewModel: SwipeViewModel(
            modelContext: ModelContext(
                try! ModelContainer(for: Intervention.self, SwipeDecision.self)
            )
        )
    )
}
