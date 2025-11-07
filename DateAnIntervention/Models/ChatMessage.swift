//
//  ChatMessage.swift
//  DateAnIntervention
//
//  Created by Claude on 2025-11-06.
//

import Foundation
import SwiftData

@Model
final class ChatMessage {
    var id: UUID
    var content: String
    var timestamp: Date
    var isFromUser: Bool

    // Relationship
    var intervention: Intervention?

    init(
        id: UUID = UUID(),
        content: String,
        timestamp: Date = Date(),
        isFromUser: Bool,
        intervention: Intervention? = nil
    ) {
        self.id = id
        self.content = content
        self.timestamp = timestamp
        self.isFromUser = isFromUser
        self.intervention = intervention
    }
}
