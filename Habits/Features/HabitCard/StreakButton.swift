//
//  StreakButton.swift
//  Habits
//
//  Created by Andrey on 04/05/2026.
//

import SwiftUI
import SwiftData

struct StreakButton: View {
    
    @Query private var records: [Record]
    
    private let habit: Habit
    
    private let calendar = Calendar.current
    
    private var todayRecord: Record? {
        records.first { calendar.isDate($0.timestamp, inSameDayAs: .now) }
    }
    
    private var isTodayChecked: Bool {
        todayRecord != nil
    }
    
    private var streak: Int {
        guard !records.isEmpty else { return 0 }
        
        var streak = 0
        var dateToCheck = Date.startOfToday
        let recordDates: Set<Date> = Set(records.map { calendar.startOfDay(for: $0.timestamp) })
        
        if !recordDates.contains(dateToCheck) {
            dateToCheck = calendar.date(byAdding: .day, value: -1, to: .startOfToday)!
        }
        
        while recordDates.contains(dateToCheck) {
            streak += 1
            dateToCheck = calendar.date(byAdding: .day, value: -1, to: dateToCheck)!
        }
        
        return streak
    }
    
    init(habit: Habit) {
        self.habit = habit
        
        let fetchedRecordsHabitID = habit.persistentModelID
        
        let predicate = #Predicate<Record> { record in
            record.habit.persistentModelID == fetchedRecordsHabitID
        }
        
        self._records = Query(filter: predicate, sort: \.timestamp)
    }
    
    var body: some View {
        Button {
            if let todayRecord {
                DataManager.shared.delete(todayRecord)
            } else {
                DataManager.shared.insert(Record(habit: habit))
            }
        } label: {
            HStack(spacing: 2) {
                Image(systemName: "bolt.fill")
                Text(String(streak))
            }
            .padding(8)
            .font(.headline)
            .frame(height: 38)
            .foregroundStyle(isTodayChecked ? .streakButtonLabelChecked : .accent)
            .background(isTodayChecked ? .accent : .clear, in: RoundedRectangle(cornerRadius: 12))
        }
    }
}

#Preview {
    let habit = Habit(emoji: "🎯", title: "Preview Habit")
    
    StreakButton(habit: habit)
}
