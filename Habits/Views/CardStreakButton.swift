//
//  CardStreakButton.swift
//  Habits
//
//  Created by Andrey on 24/12/2025.
//

import SwiftUI
import SwiftData

// MARK: - Review

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
            let dateToCompare = calendar.date(byAdding: .day, value: index, to: startOfToday)!
            
            if records.contains(where: { $0.date == dateToCompare }) {
                count += 1
                index -= 1
            } else { break }
        }
        
        return count
    }
    
    private var hasTodayRecord: Bool {
        return records.first?.date == startOfToday
    }
    
    private var fontColor: Color {
        hasTodayRecord ? .white : .labelVibrantPrimary
    }
    
    private var horizontalPadding: CGFloat {
        hasTodayRecord ? 8 : 0
    }
    
    private var verticalPadding: CGFloat {
        hasTodayRecord ? 6 : 0
    }
    
    private let imageToCountSpacing: CGFloat = 2
    
    init(habit: Habit) {
        self.habit = habit
        self.calendar = Calendar.current
        
        let habitIDToFetch = habit.persistentModelID
        let predicate = #Predicate<Record> { $0.habit.persistentModelID == habitIDToFetch }
        _records = Query(filter: predicate, sort: \Record.date, order: .reverse)
    }
    
    var body: some View {
        ZStack {
            if hasTodayRecord {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.labelVibrantPrimary)
            }
            HStack(spacing: imageToCountSpacing) {
                Image(systemName: "bolt.fill")
                Text(streak.description)
            }
            .font(.headline)
            .foregroundStyle(fontColor)
            .frame(height: 22)
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
        }
        .fixedSize()
        .onTapGesture {
            if hasTodayRecord {
                do {
                    if let recordToDelete = records.first {
                        context.delete(recordToDelete)
                    } else {
                        fatalError("Failed to get recordToDelete in CardStreakButton")
                    }
                    try context.save()
                } catch {
                    fatalError("Failed to save persistent storage after deleting record: \(error)")
                }
            } else {
                do {
                    let recordToInsert = Record(date: startOfToday, habit: habit)
                    context.insert(recordToInsert)
                    try context.save()
                } catch {
                    fatalError("Failed to save persistent storage after inserting record: \(error)")
                }
            }
        }
    }
}

#Preview {
    VStackLayout(spacing: 16) {
        CardHabitCalendar(displayedMonths: [.now], habit: SampleData.shared.sampleHabit)
        CardStreakButton(habit: SampleData.shared.sampleHabit)
    }
    .modelContainer(SampleData.shared.container)
}
