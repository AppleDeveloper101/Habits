//
//  Record.swift
//  Habits
//
//  Created by Andrey on 29/04/2026.
//

import Foundation
import SwiftData

@Model class Record {
    
    var habit: Habit?
    var timestamp: Date
    
    init(
        habit: Habit,
        timestamp: Date = .now
    ) {
        self.habit = habit
        self.timestamp = timestamp
    }
}
