//
//  InterventionCategory.swift
//  DateAnIntervention
//
//  Created by Claude on 2025-11-06.
//

import Foundation

enum InterventionCategory: String, Codable, CaseIterable {
    case stratospheric = "Stratospheric/SRM"
    case oceanBased = "Ocean-Based"
    case icePreservation = "Ice Preservation"
    case localized = "Localized/Regional"
    case openSystems = "Open Systems"
    case landBased = "Land-Based"

    var displayName: String {
        return self.rawValue
    }

    var emoji: String {
        switch self {
        case .stratospheric:
            return "☁️"
        case .oceanBased:
            return "🌊"
        case .icePreservation:
            return "🧊"
        case .localized:
            return "🌱"
        case .openSystems:
            return "🌍"
        case .landBased:
            return "🌲"
        }
    }
}
