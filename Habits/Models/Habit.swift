//
//  Habit.swift
//  Habits
//
//  Created by Andrey on 29/04/2026.
//

import Foundation
import SwiftData

@Model class Habit {
    
    @Attribute(.unique) var id: UUID
    
    var emoji: String
    var title: String
    var timestamp: Date
    
    @Relationship(deleteRule: .cascade, inverse: \Record.habit) var records: [Record]
    
    init(
        emoji: String,
        title: String,
    ) {
        self.id = UUID()
        self.emoji = emoji
        self.title = title
        self.timestamp = .now
        self.records = []
    }
}
