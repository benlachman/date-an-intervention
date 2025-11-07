//
//  MatchesView.swift
//  DateAnIntervention
//
//  Created by Claude on 2025-11-06.
//

import SwiftUI
import SwiftData

struct MatchesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(filter: #Predicate<SwipeDecision> { $0.liked == true })
    private var likedDecisions: [SwipeDecision]

    @State private var selectedIntervention: Intervention?
    @State private var showingProfile = false

    var body: some View {
        NavigationStack {
            ZStack {
                if likedDecisions.isEmpty {
                    EmptyMatchesView()
                } else {
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.flexible(), alignment: .top),
                            GridItem(.flexible(), alignment: .top)
                        ], spacing: 16) {
                            ForEach(likedDecisions, id: \.id) { decision in
                                if let intervention = decision.intervention {
                                    MatchCardView(intervention: intervention)
                                        .onTapGesture {
                                            selectedIntervention = intervention
                                            showingProfile = true
                                        }
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Matches")
            .sheet(isPresented: $showingProfile) {
                if let intervention = selectedIntervention {
                    ProfileDetailView(intervention: intervention)
                }
            }
        }
    }
}

struct EmptyMatchesView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "flame")
                .font(.system(size: 60))
                .foregroundStyle(.pink)

            Text("No Matches Yet")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Start swiping to find interventions you'd support!")
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
    }
}

struct MatchCardView: View {
    let intervention: Intervention

    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            ZStack {
                LinearGradient(
                    colors: intervention.gradientColors.compactMap { Color(hex: $0) },
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                Image(systemName: intervention.sfSymbol)
                    .font(.system(size: 40))
                    .foregroundStyle(.white)
            }
            .frame(height: 120)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            Text(intervention.name)
                .font(.subheadline)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .top)
        }
        .frame(maxWidth: .infinity, alignment: .top)
    }
}

#Preview {
    MatchesView()
        .modelContainer(for: SwipeDecision.self, inMemory: true)
}
