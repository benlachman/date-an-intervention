//
//  ProfileDetailView.swift
//  DateAnIntervention
//
//  Created by Claude on 2025-11-07.
//

import SwiftUI

struct ProfileDetailView: View {
    let intervention: Intervention
    @Environment(\.dismiss) private var dismiss
    @State private var showChat = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Image carousel at the top
                    ImageCarouselView(intervention: intervention)
                        .frame(height: 450)

                    // Main content
                    VStack(alignment: .leading, spacing: 24) {
                        // Name and category
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(intervention.name)
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundStyle(.primary)

                                Spacer()
                            }

                            HStack {
                                Text(intervention.category.emoji)
                                    .font(.body)

                                Text(intervention.category.displayName)
                                    .font(.body)
                                    .foregroundStyle(.secondary)
                            }
                        }

                        Divider()

                        // Bio section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("About")
                                .font(.headline)
                                .foregroundStyle(.primary)

                            Text(intervention.bio)
                                .font(.body)
                                .foregroundStyle(.primary)
                                .lineSpacing(4)
                        }

                        Divider()

                        // Stats grid
                        StatsGridView(intervention: intervention)

                        Divider()

                        // Interests (pros)
                        if !intervention.pros.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Strengths")
                                    .font(.headline)
                                    .foregroundStyle(.primary)

                                VStack(alignment: .leading, spacing: 8) {
                                    ForEach(intervention.pros, id: \.self) { pro in
                                        HStack(alignment: .top, spacing: 8) {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundStyle(.green)
                                                .font(.body)

                                            Text(pro)
                                                .font(.body)
                                                .foregroundStyle(.primary)
                                        }
                                    }
                                }
                            }

                            Divider()
                        }

                        // Dealbreakers (cons)
                        if !intervention.cons.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Challenges")
                                    .font(.headline)
                                    .foregroundStyle(.primary)

                                VStack(alignment: .leading, spacing: 8) {
                                    ForEach(intervention.cons, id: \.self) { con in
                                        HStack(alignment: .top, spacing: 8) {
                                            Image(systemName: "exclamationmark.triangle.fill")
                                                .foregroundStyle(.orange)
                                                .font(.body)

                                            Text(con)
                                                .font(.body)
                                                .foregroundStyle(.primary)
                                        }
                                    }
                                }
                            }
                        }

                        // Bottom spacing for button
                        Spacer(minLength: 100)
                    }
                    .padding(20)
                }
            }
            .ignoresSafeArea(edges: .top)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.down.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.white)
                            .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                    }
                }
            }
            .overlay(alignment: .bottom) {
                // Message button
                Button {
                    showChat = true
                } label: {
                    HStack {
                        Image(systemName: "message.fill")
                        Text("Message")
                            .fontWeight(.semibold)
                    }
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            colors: intervention.gradientColors.compactMap { Color(hex: $0) },
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                .background(
                    // Background blur with gradient transparency
                    ZStack {
                        Rectangle()
                            .fill(.ultraThinMaterial)
                            .mask(
                                LinearGradient(
                                    colors: [.clear, .black],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    }
                    .ignoresSafeArea(edges: .bottom)
                )
            }
            .sheet(isPresented: $showChat) {
                ChatView(intervention: intervention)
            }
        }
    }
}

#Preview {
    ProfileDetailView(
        intervention: Intervention(
            name: "Stratospheric Aerosol Injection",
            category: .stratospheric,
            bio: "High-altitude dreamer looking to cool things down. I work in the stratosphere, literally above it all. My approach is bold and direct - spray reflective particles into the upper atmosphere to bounce sunlight back into space. Some call me controversial, but I get results fast.",
            pros: ["Fast acting", "Low cost", "Global scale", "Reversible"],
            cons: ["Regional climate disruption", "Governance challenges", "Unknown side effects"],
            sfSymbol: "cloud.sun.fill",
            gradientColors: ["#FF6B35", "#764ba2"],
            researchLevel: 7,
            techReadiness: 4,
            publicSupport: 3,
            flirtStyle: "Bold and direct",
            openingLine: "Hey there! Ready to change the world?",
            systemPrompt: "You are SAI."
        )
    )
}
