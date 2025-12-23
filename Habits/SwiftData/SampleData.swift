//
//  SampleData.swift
//  Habits
//
//  Created by Andrey on 23/12/2025.
//

import Foundation
import SwiftData

class SampleData {
    static let shared = SampleData()
    
    let container: ModelContainer
    let context: ModelContext
    let sampleHabit: Habit
    
    private init() {
        do {
            let schema = Schema([
                Habit.self,
                Record.self,
            ])
            let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
            
            container = try ModelContainer(for: schema, configurations: configuration)
            context = container.mainContext
            sampleHabit = Habit(title: "Sample Habit", emoji: "🌁")
            
            let calendar = Calendar.current
            let startOfToday = calendar.startOfDay(for: .now)
            let dayOffsets = [-14, -7, -4, -3, -2, 0]
            let records = dayOffsets.map { offset in
                if let date = calendar.date(byAdding: .day, value: offset, to: startOfToday) {
                    return Record(date: date, habit: sampleHabit)
                } else {
                    fatalError("Failed to get date from offset during SampleData initialization")
                }
            }
            
            context.insert(sampleHabit)
            records.forEach { context.insert($0) }
            try context.save()
        } catch {
            fatalError("Error occurred during SampleData initialization: \(error)")
        }
    }
}
