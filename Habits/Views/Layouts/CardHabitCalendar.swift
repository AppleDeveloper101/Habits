//
//  CardHabitCalendar.swift
//  Habits
//
//  Created by Andrey on 23/12/2025.
//

import SwiftUI

struct CardHabitCalendar: View {
    private let displayedMonths: [Date]
    private let habit: Habit
    
    private let columnToGridSpacing: CGFloat = 2
    private let gridToGridSpacing: CGFloat = 8
    
    init(displayedMonths: [Date], habit: Habit) {
        self.displayedMonths = displayedMonths
        self.habit = habit
    }
    
    var body: some View {
        HStack(alignment: .bottom, spacing: columnToGridSpacing) {
            CardWeekdaysColumn()
            
            HStack(spacing: gridToGridSpacing) {
                ForEach(displayedMonths, id: \.self) { monthDate in
                    CardMonthGrid(date: monthDate, habit: habit)
                }
            }
        }
    }
}

#if DEBUG

import Foundation
import SwiftData

#Preview {
    // TODO: Implement adaptive algorithm (pass from HabitCard?)
    let calendar = Calendar.current
    var displayedMonths: [Date] {
        guard let startOfFirstDisplayedMonth = calendar.dateInterval(of: .month, for: .now)?.start else {
            fatalError("Failed to retrieve startOfFirstShownMonth in CardHabitCalendar")
        }
        
        return (-1..<3).map { offset in
            guard let date = calendar.date(byAdding: .month, value: offset, to: startOfFirstDisplayedMonth) else {
                fatalError("Failed to retrieve date in CardHabitCalendar")
            }
            return date
        }
    }
    
    CardHabitCalendar(displayedMonths: displayedMonths, habit: Habit.sample)
        .modelContainer(sampleContainer)
        .containerRelativeFrame(.horizontal, alignment: .leading)
        .padding(.leading)
}
#endif
