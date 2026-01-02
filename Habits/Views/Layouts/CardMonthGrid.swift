//
//  CardMonthGrid.swift
//  Habits
//
//  Created by Andrey on 23/12/2025.
//

import SwiftUI
import SwiftData

struct CardMonthGrid: View {
    @Query private var records: [Record]
    
    private let date: Date
    private let calendar: Calendar
    
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
    
    private var paddingCellsCount: Int {
        let startOfMonthWeekday = calendar.component(.weekday, from: startOfMonth)
        let systemFirstWeekday = calendar.firstWeekday
        return (startOfMonthWeekday - systemFirstWeekday + 7) % 7
    }
    
    private let headerToGridSpacing: CGFloat = 4
    private let gridSpacing: CGFloat = 2
    private var gridItems: [GridItem] {
        Array(repeating: GridItem(spacing: gridSpacing), count: 7)
    }
    
    init(date: Date, habit: Habit) {
        self.date = date
        self.calendar = Calendar.current
        
        let habitIDToFetch = habit.persistentModelID
        let predicate = #Predicate<Record> { $0.habit?.persistentModelID == habitIDToFetch }
        _records = Query(filter: predicate)
    }
    
    var body: some View {
        VStack(spacing: headerToGridSpacing) {
            CardMonthHeader(date: startOfMonth)
            
            LazyHGrid(rows: gridItems, spacing: gridSpacing) {
                ForEach(0..<paddingCellsCount, id: \.self) { _ in
                    CardPaddingCell()
                }
                ForEach(monthDays, id: \.self) { cellDate in
                    CardDayCell(
                        hasRecord: records.contains { $0.date == cellDate },
                        isToday: calendar.isDate(.now, equalTo: cellDate, toGranularity: .day)
                    )
                }
            }
        }
        .fixedSize()
    }
}

#Preview {
    CardMonthGrid(date: .now, habit: sampleHabit)
        .modelContainer(sampleContainer)
}
