//
//  DataManager.swift
//  Habits
//
//  Created by Andrey on 30/04/2026.
//

import Foundation
import SwiftData

final class DataManager {
    
    static let shared = DataManager()
    
    let container: ModelContainer
    let context: ModelContext
    
    private init() {
        self.container = try! ModelContainer(for: Habit.self, Record.self)
        self.context = container.mainContext
    }
    
    func insert( _ model: any PersistentModel) {
        context.insert(model)
    }
    
    func delete( _ model: any PersistentModel) {
        context.delete(model)
    }
    
    func toggleRecord(for habit: Habit, on date: Date) {
        let calendar = Calendar.current
        
        guard let recordToDelete = habit.records.first(where: { record in
            calendar.isDate(record.timestamp, inSameDayAs: date)
        }) else {
            insert(Record(habit: habit, timestamp: date))
            return
        }
        
        delete(recordToDelete)
    }
}
