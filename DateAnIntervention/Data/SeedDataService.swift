//
//  SeedDataService.swift
//  DateAnIntervention
//
//  Created by Claude on 2025-11-06.
//

import Foundation
import SwiftData

struct SeedDataService {

    /// Seeds the database with interventions if it's empty
    static func seedInterventionsIfNeeded(context: ModelContext) {
        // Check if we already have interventions
        let descriptor = FetchDescriptor<Intervention>()
        let existingCount = (try? context.fetchCount(descriptor)) ?? 0

        if existingCount == 0 {
            print("📊 Seeding interventions data...")
            seedInterventions(context: context)
        } else {
            print("✅ Database already has \(existingCount) interventions")
        }
    }

    /// Seeds the database with all intervention data
    private static func seedInterventions(context: ModelContext) {
        let interventions = InterventionsData.allInterventions

        for intervention in interventions {
            context.insert(intervention)
        }

        do {
            try context.save()
            print("✅ Successfully seeded \(interventions.count) interventions")
        } catch {
            print("❌ Error saving interventions: \(error)")
        }
    }
}
