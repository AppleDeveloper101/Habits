//
//  SampleData.swift
//  Habits
//
//  Created by Andrey on 23/12/2025.
//

import Foundation
import SwiftData

let sampleContainer: ModelContainer = {
    do {
        let schema = Schema([
            Habit.self,
            Record.self,
        ])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        
        let container = try ModelContainer(for: schema, configurations: configuration)
        let context = container.mainContext
        
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: .now)
        let dayOffsets = [-14, -7, -4, -3, -2, 0]
        let records = dayOffsets.map { offset in
            if let date = calendar.date(byAdding: .day, value: offset, to: startOfToday) {
                return Record(date: date, habit: Habit.sample)
            } else {
                fatalError("Failed to get date from offset during SampleData initialization")
            }
        }
        
        context.insert(Habit.sample)
        records.forEach { context.insert($0) }
        
        try context.save()
        
        return container
    } catch {
        fatalError("Error occurred during SampleData initialization: \(error)")
    }
}()
