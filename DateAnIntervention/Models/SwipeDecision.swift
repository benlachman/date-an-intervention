//
//  SwipeDecision.swift
//  DateAnIntervention
//
//  Created by Claude on 2025-11-06.
//

import Foundation
import SwiftData

@Model
final class SwipeDecision {
    var id: UUID
    var timestamp: Date
    var liked: Bool

    // Relationship
    var intervention: Intervention?

    init(id: UUID = UUID(), timestamp: Date = Date(), liked: Bool, intervention: Intervention? = nil) {
        self.id = id
        self.timestamp = timestamp
        self.liked = liked
        self.intervention = intervention
    }
}
