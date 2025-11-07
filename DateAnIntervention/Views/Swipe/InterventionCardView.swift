//
//  InterventionCardView.swift
//  DateAnIntervention
//
//  Created by Claude on 2025-11-06.
//

import SwiftUI

struct InterventionCardView: View {
    let intervention: Intervention

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                // Background gradient with SF Symbol
                ZStack {
                    LinearGradient(
                        colors: intervention.gradientColors.compactMap { Color(hex: $0) },
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )

                    // Large SF Symbol in background
                    Image(systemName: intervention.sfSymbol)
                        .font(.system(size: min(geometry.size.width, geometry.size.height) * 0.5))
                        .foregroundStyle(.white.opacity(0.3))
                        .offset(y: 30)
                }

                // Bottom info card
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(intervention.name)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)

                        Spacer()
                    }

                    // Category badge
                    HStack {
                        Text(intervention.category.displayName)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(.white.opacity(0.3))
                            )

                        Spacer()
                    }

                    // Bio preview
                    Text(intervention.bio)
                        .font(.body)
                        .foregroundStyle(.white)
                        .lineLimit(3)
                        .padding(.top, 4)
                }
                .padding(20)
                .background(
                    LinearGradient(
                        colors: [.clear, .black.opacity(0.7)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    InterventionCardView(
        intervention: Intervention(
            name: "Stratospheric Aerosol Injection",
            category: .stratospheric,
            bio: "High-altitude dreamer looking to cool things down. I work in the stratosphere, literally above it all.",
            pros: ["Fast acting", "Low cost"],
            cons: ["Controversial", "Risky"],
            sfSymbol: "cloud.sun.fill",
            gradientColors: ["#FF6B35", "#764ba2"],
            researchLevel: 7,
            techReadiness: 4,
            publicSupport: 3,
            flirtStyle: "Bold",
            openingLine: "Hey there!",
            systemPrompt: "You are SAI."
        )
    )
    .frame(width: 350, height: 500)
    .padding()
}
