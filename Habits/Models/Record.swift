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
    private(set) var date: Date
    private(set) var habit: Habit?
    
    init(date: Date, habit: Habit) {
        self.date = date
        self.habit = habit
    }
}
