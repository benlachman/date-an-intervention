//
//  StatsGridView.swift
//  DateAnIntervention
//
//  Created by Claude on 2025-11-07.
//

import SwiftUI

struct StatsGridView: View {
    let intervention: Intervention

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Stats")
                .font(.headline)
                .foregroundStyle(.primary)

            HStack(spacing: 16) {
                StatItemView(
                    icon: "chart.line.uptrend.xyaxis",
                    label: "Research",
                    value: intervention.researchLevel,
                    maxValue: 10,
                    color: .blue
                )

                StatItemView(
                    icon: "gearshape.2.fill",
                    label: "Tech Ready",
                    value: intervention.techReadiness,
                    maxValue: 10,
                    color: .purple
                )

                StatItemView(
                    icon: "person.3.fill",
                    label: "Support",
                    value: intervention.publicSupport,
                    maxValue: 10,
                    color: .green
                )
            }
        }
    }
}

struct StatItemView: View {
    let icon: String
    let label: String
    let value: Int
    let maxValue: Int
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            // Icon in circle
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 50, height: 50)

                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundStyle(color)
            }

            // Value
            Text("\(value)")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(.primary)

            // Label
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background
                    RoundedRectangle(cornerRadius: 2)
                        .fill(color.opacity(0.2))
                        .frame(height: 4)

                    // Filled portion
                    RoundedRectangle(cornerRadius: 2)
                        .fill(color)
                        .frame(width: geometry.size.width * CGFloat(value) / CGFloat(maxValue), height: 4)
                }
            }
            .frame(height: 4)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    StatsGridView(
        intervention: Intervention(
            name: "Stratospheric Aerosol Injection",
            category: .stratospheric,
            bio: "High-altitude dreamer looking to cool things down.",
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
    .padding()
}
