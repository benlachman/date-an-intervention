//
//  SwipeView.swift
//  DateAnIntervention
//
//  Created by Claude on 2025-11-06.
//

import SwiftUI
import SwiftData

struct SwipeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var interventions: [Intervention]

    @State private var viewModel: SwipeViewModel?
    @State private var selectedIntervention: Intervention?

    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [Color.pink.opacity(0.1), Color.purple.opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack {
                    if interventions.isEmpty {
                        EmptyStateView()
                    } else if let viewModel = viewModel {
                        VStack {
                            CardStackView(viewModel: viewModel)
                                .padding(.top, 20)

                            // Action buttons
                            if !viewModel.isEmpty {
                                actionButtons(viewModel: viewModel)
                            }
                        }
                    } else {
                        ProgressView("Loading...")
                    }
                }
            }
            .navigationTitle("Discover")
            .onAppear {
                if viewModel == nil {
                    viewModel = SwipeViewModel(modelContext: modelContext)
                }
            }
            .sheet(item: $selectedIntervention) { intervention in
                ProfileDetailView(intervention: intervention)
            }
        }
    }

    // MARK: - Action Buttons

    @ViewBuilder
    private func actionButtons(viewModel: SwipeViewModel) -> some View {
        HStack(spacing: 30) {
            // Dislike button
            Button {
                if let current = viewModel.currentIntervention {
                    viewModel.swipeLeft(on: current)
                }
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 48, height: 48)
                    .background(
                        Circle()
                            .fill(.red)
                            .shadow(color: .red.opacity(0.4), radius: 8, x: 0, y: 4)
                    )
            }

            // Info button
            Button {
                if let current = viewModel.currentIntervention {
                    selectedIntervention = current
                }
            } label: {
                Image(systemName: "info.circle.fill")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.blue)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(Color(uiColor: .systemBackground))
                            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                    )
            }

            // Like button
            Button {
                if let current = viewModel.currentIntervention {
                    viewModel.swipeRight(on: current)
                }
            } label: {
                Image(systemName: "heart.fill")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 48, height: 48)
                    .background(
                        Circle()
                            .fill(.green)
                            .shadow(color: .green.opacity(0.4), radius: 8, x: 0, y: 4)
                    )
            }
        }
        .padding(.bottom, 30)
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "heart.slash.circle")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)

            Text("No Interventions Yet")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Check back soon for climate interventions to explore!")
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
    }
}

#Preview {
    SwipeView()
        .modelContainer(for: Intervention.self, inMemory: true)
}
