//
//  DateAnInterventionApp.swift
//  DateAnIntervention
//
//  Created by Claude on 2025-11-06.
//

import SwiftUI
import SwiftData

@main
struct DateAnInterventionApp: App {

    // MARK: - SwiftData Container

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Intervention.self,
            SwipeDecision.self,
            ChatMessage.self
        ])

        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])

            // Seed data on first launch
            let context = container.mainContext
            SeedDataService.seedInterventionsIfNeeded(context: context)

            return container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    // MARK: - Body

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
