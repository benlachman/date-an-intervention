//
//  InterventionsData.swift
//  DateAnIntervention
//
//  Created by Claude on 2025-11-06.
//
//  This file loads intervention data from interventions.json
//

import Foundation

struct InterventionsData {

    /// Decodable structure matching JSON format
    struct InterventionJSON: Decodable {
        let name: String
        let category: String
        let bio: String
        let pros: [String]
        let cons: [String]
        let sfSymbol: String
        let gradientColors: [String]
        let researchLevel: Int
        let techReadiness: Int
        let publicSupport: Int
        let flirtStyle: String
        let openingLine: String
        let systemPrompt: String
    }

    /// All interventions to be seeded into the database
    static var allInterventions: [Intervention] {
        guard let url = Bundle.main.url(forResource: "interventions", withExtension: "json") else {
            print("❌ Error: Could not find interventions.json")
            return []
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let jsonInterventions = try decoder.decode([InterventionJSON].self, from: data)

            return jsonInterventions.compactMap { json -> Intervention? in
                // Map category string to enum
                guard let category = categoryFromString(json.category) else {
                    print("❌ Error: Unknown category '\(json.category)' for intervention '\(json.name)'")
                    return nil
                }

                return Intervention(
                    name: json.name,
                    category: category,
                    bio: json.bio,
                    pros: json.pros,
                    cons: json.cons,
                    sfSymbol: json.sfSymbol,
                    gradientColors: json.gradientColors,
                    researchLevel: json.researchLevel,
                    techReadiness: json.techReadiness,
                    publicSupport: json.publicSupport,
                    flirtStyle: json.flirtStyle,
                    openingLine: json.openingLine,
                    systemPrompt: json.systemPrompt
                )
            }
        } catch {
            print("❌ Error loading interventions from JSON: \(error)")
            return []
        }
    }

    /// Helper to map category string to enum
    private static func categoryFromString(_ string: String) -> InterventionCategory? {
        switch string.lowercased() {
        case "stratospheric":
            return .stratospheric
        case "oceanbased", "ocean-based":
            return .oceanBased
        case "icepreservation", "ice-preservation":
            return .icePreservation
        case "localized":
            return .localized
        case "opensystems", "open-systems":
            return .openSystems
        case "landbased", "land-based":
            return .landBased
        default:
            return nil
        }
    }
}
