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
                    } else {
                        Text("Swipe interface coming soon!")
                            .font(.title)
                            .padding()

                        Text("\(interventions.count) interventions loaded")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Discover")
        }
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
