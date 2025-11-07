//
//  ImageCarouselView.swift
//  DateAnIntervention
//
//  Created by Claude on 2025-11-07.
//

import SwiftUI

struct ImageCarouselView: View {
    let intervention: Intervention
    @State private var currentPage = 0

    // For now, we'll show 3 variations of the same SF Symbol with different gradient styles
    // In the future, this could be expanded to show actual photos
    private var imageCount: Int { 3 }

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $currentPage) {
                ForEach(0..<imageCount, id: \.self) { index in
                    gradientImageView(for: index)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .ignoresSafeArea()

            // Custom page indicator
            HStack(spacing: 8) {
                ForEach(0..<imageCount, id: \.self) { index in
                    Circle()
                        .fill(currentPage == index ? .white : .white.opacity(0.5))
                        .frame(width: 8, height: 8)
                }
            }
            .padding(.bottom, 20)
        }
    }

    @ViewBuilder
    private func gradientImageView(for index: Int) -> some View {
        ZStack {
            // Background gradient - vary the angle based on index
            LinearGradient(
                colors: intervention.gradientColors.compactMap { Color(hex: $0) },
                startPoint: gradientStartPoint(for: index),
                endPoint: gradientEndPoint(for: index)
            )

            // SF Symbol overlay
            Image(systemName: intervention.sfSymbol)
                .font(.system(size: symbolSize(for: index)))
                .foregroundStyle(.white.opacity(symbolOpacity(for: index)))
                .rotationEffect(.degrees(symbolRotation(for: index)))
        }
    }

    // Vary gradient direction for each page
    private func gradientStartPoint(for index: Int) -> UnitPoint {
        switch index {
        case 0: return .topLeading
        case 1: return .top
        case 2: return .topTrailing
        default: return .topLeading
        }
    }

    private func gradientEndPoint(for index: Int) -> UnitPoint {
        switch index {
        case 0: return .bottomTrailing
        case 1: return .bottom
        case 2: return .bottomLeading
        default: return .bottomTrailing
        }
    }

    // Vary symbol size for visual interest
    private func symbolSize(for index: Int) -> CGFloat {
        switch index {
        case 0: return 200
        case 1: return 180
        case 2: return 220
        default: return 200
        }
    }

    // Vary symbol opacity
    private func symbolOpacity(for index: Int) -> Double {
        switch index {
        case 0: return 0.3
        case 1: return 0.4
        case 2: return 0.25
        default: return 0.3
        }
    }

    // Vary symbol rotation
    private func symbolRotation(for index: Int) -> Double {
        switch index {
        case 0: return 0
        case 1: return -15
        case 2: return 15
        default: return 0
        }
    }
}

#Preview {
    ImageCarouselView(
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
    .frame(height: 450)
}
