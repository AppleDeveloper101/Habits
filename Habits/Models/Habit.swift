//
//  Habit.swift
//  Habits
//
//  Created by Andrey on 23/12/2025.
//

import Foundation
import SwiftData

@Model
class Habit {
    
    // MARK: - Properties
    
    var title: String
    var emoji: String
    var created: Date
    @Relationship(deleteRule: .cascade, inverse: \Record.habit)
    var records: [Record]?
    
    // MARK: - Initializers
    
    init(
        title: String,
        emoji: String
    ) {
        self.title = title
        self.emoji = emoji
        self.created = .now
        self.records = nil
    }
}

// MARK: - Extensions

extension Habit {
    static let sample = Habit(title: "Sample Habit", emoji: "🌁")
}
