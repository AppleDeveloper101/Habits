//
//  CardStreakButton.swift
//  Habits
//
//  Created by Andrey on 24/12/2025.
//

import SwiftUI
import SwiftData

struct CardStreakButton: View {
    @Environment(\.modelContext) private var context
    
    @Query private var records: [Record]
    
    private let habit: Habit
    private let calendar: Calendar
    
    private var startOfToday: Date {
        calendar.startOfDay(for: .now)
    }
    
    private var streak: Int {
        var count = hasTodayRecord ? 1 : 0
        
        if records.isEmpty { return count }
        
        var index = -1
        while true {
            guard let dateToCompare = calendar.date(byAdding: .day, value: index, to: startOfToday) else {
                fatalError("Failed to retrieve dateToCompare in CardStreakButton")
            }
            
            if records.contains(where: { $0.date == dateToCompare }) {
                count += 1
                index -= 1
            } else { break }
        }
        
        return count
    }
    
    private var hasTodayRecord: Bool {
        return records.contains { $0.date == startOfToday }
    }
    
    private var fontColor: Color {
        hasTodayRecord ? .white : .labelVibrantPrimary
    }
    
    private let outerPadding: CGFloat = 8
    private let imageToCountSpacing: CGFloat = 2
    
    init(habit: Habit) {
        self.habit = habit
        self.calendar = Calendar.current
        
        let habitIDToFetch = habit.persistentModelID
        let predicate = #Predicate<Record> { $0.habit?.persistentModelID == habitIDToFetch }
        _records = Query(filter: predicate, sort: \Record.date, order: .reverse)
    }
    
    var body: some View {
        HStack(spacing: imageToCountSpacing) {
            Image(systemName: "bolt.fill")
            Text(streak.description)
        }
        .font(.headline)
        .foregroundStyle(fontColor)
        .frame(height: 22)
        .padding(outerPadding)
        .background {
            if hasTodayRecord {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.labelVibrantPrimary)
            }
        }
        .onTapGesture {
            if hasTodayRecord {
                guard let recordToDelete = records.first(where: { $0.date == startOfToday }) else {
                    fatalError("Failed to get recordToDelete in CardStreakButton")
                }
                context.delete(recordToDelete)
            } else {
                let recordToInsert = Record(date: startOfToday, habit: habit)
                context.insert(recordToInsert)
            }
            
            if context.hasChanges {
                do { try context.save() } catch {
                    fatalError("Failed to save persistent storage: \(error)")
                }
            }
        }
    }
}

#Preview {
    CardStreakButton(habit: sampleHabit)
        .modelContainer(sampleContainer)
}
