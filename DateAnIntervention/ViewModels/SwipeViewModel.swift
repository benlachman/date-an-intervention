//
//  SwipeViewModel.swift
//  DateAnIntervention
//
//  Created by Claude on 2025-11-06.
//

import Foundation
import SwiftData
import Observation

@Observable
class SwipeViewModel {
    private var modelContext: ModelContext

    // Current interventions to swipe through
    var interventions: [Intervention] = []

    // Index of current card
    var currentIndex: Int = 0

    // Computed property for current intervention
    var currentIntervention: Intervention? {
        guard currentIndex < interventions.count else { return nil }
        return interventions[currentIndex]
    }

    // Check if deck is empty
    var isEmpty: Bool {
        return currentIndex >= interventions.count
    }

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadInterventions()
    }

    // MARK: - Data Loading

    private func loadInterventions() {
        let descriptor = FetchDescriptor<Intervention>(
            sortBy: [SortDescriptor(\.name)]
        )

        do {
            let allInterventions = try modelContext.fetch(descriptor)
            // Filter out interventions that have already been swiped
            interventions = allInterventions.filter { intervention in
                // Check if there's already a swipe decision for this intervention
                let swipeDescriptor = FetchDescriptor<SwipeDecision>(
                    predicate: #Predicate<SwipeDecision> { decision in
                        decision.intervention?.id == intervention.id
                    }
                )
                let existingDecisions = (try? modelContext.fetchCount(swipeDescriptor)) ?? 0
                return existingDecisions == 0
            }
        } catch {
            print("Error loading interventions: \(error)")
        }
    }

    // MARK: - Swipe Actions

    func swipeRight(on intervention: Intervention) {
        saveDecision(for: intervention, liked: true)
        moveToNextCard()
    }

    func swipeLeft(on intervention: Intervention) {
        saveDecision(for: intervention, liked: false)
        moveToNextCard()
    }

    private func saveDecision(for intervention: Intervention, liked: Bool) {
        let decision = SwipeDecision(
            liked: liked,
            intervention: intervention
        )

        modelContext.insert(decision)

        do {
            try modelContext.save()
        } catch {
            print("Error saving swipe decision: \(error)")
        }
    }

    private func moveToNextCard() {
        currentIndex += 1
    }

    // MARK: - Utility

    func reset() {
        currentIndex = 0
        loadInterventions()
    }
}
