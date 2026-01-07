//
//  SheetMonthGrid.swift
//  Habits
//
//  Created by Andrey on 07/01/2026.
//

import SwiftUI
import SwiftData

struct SheetMonthGrid: View {
    @Query private var records: [Record]
    
    private let date: Date
    private let habit: Habit
    
    private let calendar = Calendar.current
    
    private var startOfMonth: Date {
        guard let date = calendar.dateInterval(of: .month, for: date)?.start else {
            fatalError("Failed to retrieve startOfMonth in CardMonthGrid")
        }
        return date
    }
    
    private var monthDays: [Date] {
        guard let rangeOfDays = calendar.range(of: .day, in: .month, for: startOfMonth) else {
            fatalError("Failed to retrieve daysRange in CardMonthGrid")
        }
        
        return rangeOfDays.map { dayNumber in
            guard let date = calendar.date(byAdding: .day, value: dayNumber - 1, to: startOfMonth) else {
                fatalError("Failed to retrieve date in CardMonthGrid")
            }
            return date
        }
    }
    
    private let headerToGridSpacing: CGFloat = 16
    private let gridSpacing: CGFloat = 8
    
    private var gridItems: [GridItem] {
        Array(repeating: GridItem(spacing: gridSpacing), count: 7)
    }

    private var paddingCellsCount: Int {
        let startOfMonthWeekday = calendar.component(.weekday, from: startOfMonth)
        let systemFirstWeekday = calendar.firstWeekday
        return (startOfMonthWeekday - systemFirstWeekday + 7) % 7
    }
    
    init(date: Date, habit: Habit) {
        self.date = date
        self.habit = habit
    }
    
    var body: some View {
        VStack(spacing: headerToGridSpacing) {
            SheetMonthHeader(date: startOfMonth)
            
            LazyHGrid(rows: gridItems, spacing: gridSpacing) {
                ForEach(0..<paddingCellsCount, id: \.self) { _ in
                    SheetPaddingCell()
                }
                ForEach(monthDays, id: \.self) { cellDate in
                    SheetDayCell(
                        record: records.first { $0.date == cellDate },
                        date: cellDate,
                        habit: habit
                    )
                }
            }
        }
        .fixedSize()
    }
}

#Preview {
    SheetMonthGrid(date: .now, habit: sampleHabit)
        .modelContainer(sampleContainer)
}
