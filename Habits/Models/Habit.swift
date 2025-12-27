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
    var title: String
    var emoji: String
    private(set) var created: Date
    
    @Relationship(deleteRule: .cascade, inverse: \Record.habit)
    var records: [Record]?
    
    init(title: String, emoji: String) {
        self.title = title
        self.emoji = emoji
        self.created = .now
        self.records = nil
    }
}
