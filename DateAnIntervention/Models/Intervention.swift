//
//  Intervention.swift
//  DateAnIntervention
//
//  Created by Claude on 2025-11-06.
//

import Foundation
import SwiftData

@Model
final class Intervention {
    var id: UUID
    var name: String
    var categoryRaw: String
    var bio: String
    var pros: [String]
    var cons: [String]
    var sfSymbol: String
    var gradientColors: [String] // Hex color strings for gradient
    var researchLevel: Int // 1-10
    var techReadiness: Int // 1-10
    var publicSupport: Int // 1-10
    var flirtStyle: String
    var openingLine: String
    var systemPrompt: String

    // Computed property for category
    var category: InterventionCategory {
        get { InterventionCategory(rawValue: categoryRaw) ?? .openSystems }
        set { categoryRaw = newValue.rawValue }
    }

    // Relationships
    @Relationship(deleteRule: .cascade, inverse: \SwipeDecision.intervention)
    var swipeDecisions: [SwipeDecision]?

    @Relationship(deleteRule: .cascade, inverse: \ChatMessage.intervention)
    var chatMessages: [ChatMessage]?

    init(
        id: UUID = UUID(),
        name: String,
        category: InterventionCategory,
        bio: String,
        pros: [String],
        cons: [String],
        sfSymbol: String,
        gradientColors: [String],
        researchLevel: Int,
        techReadiness: Int,
        publicSupport: Int,
        flirtStyle: String,
        openingLine: String,
        systemPrompt: String
    ) {
        self.id = id
        self.name = name
        self.categoryRaw = category.rawValue
        self.bio = bio
        self.pros = pros
        self.cons = cons
        self.sfSymbol = sfSymbol
        self.gradientColors = gradientColors
        self.researchLevel = researchLevel
        self.techReadiness = techReadiness
        self.publicSupport = publicSupport
        self.flirtStyle = flirtStyle
        self.openingLine = openingLine
        self.systemPrompt = systemPrompt
    }
}
