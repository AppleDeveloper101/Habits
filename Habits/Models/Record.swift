//
//  Record.swift
//  Habits
//
//  Created by Andrey on 21/12/2025.
//

import Foundation
import SwiftData

@Model
class Record {
    
    // MARK: - Properties
    
    var date: Date
    var habit: Habit
    
    // MARK: - Initializers
    
    init(
        date: Date,
        habit: Habit
    ) {
        self.date = date
        self.habit = habit
    }
}
