//
//  WeekRowStats.swift
//  Habits
//
//  Created by Andrey on 28/05/2026.
//

import SwiftUI
import SwiftData

struct WeekRowStats: View {
    
    @Query private var records: [Record]
    
    private let habit: Habit
    
    @State private var markWidth: CGFloat = .zero
    @State private var calculatedCornerRadius: CGFloat = .zero
    
    private let cornerRadiusMultiplier = 0.34375
    
    private let lastWeekday = (Calendar.current.firstWeekday - 1 + 7) % 7
    
    private var components: DateComponents {
        DateComponents(weekday: lastWeekday)
    }
    
    private var lastWeekdayDate: Date {
        Calendar.current.nextDate(after: .now, matching: components, matchingPolicy: .nextTime)!
    }
    
    private var datesRange: [Date] {
        var dates: [Date] = []
        
        (0..<10).reversed().forEach { index in
            let dateToAdd = Calendar.current.date(byAdding: .day, value: -index, to: lastWeekdayDate)!
            dates.append(dateToAdd)
        }
        
        return dates
    }
    
    init(habit: Habit) {
        self.habit = habit
        
        let fetchedRecordsHabitID = habit.persistentModelID
        
        let predicate = #Predicate<Record> { record in
            record.habit?.persistentModelID == fetchedRecordsHabitID
        }
        
        self._records = Query(filter: predicate, sort: \.timestamp)
    }
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(Array(datesRange.enumerated()), id: \.offset) { index, date in
                WeekRowCell(
                    hasRecord: records.contains { Calendar.current.isDate($0.timestamp, equalTo: date, toGranularity: .day) },
                    isToday: Calendar.current.isDate(date, equalTo: .now, toGranularity: .day),
                    symbol: date.formatted(.dateTime.weekday(.narrow))
                )
                if index == 2 { separatorColumn() }
            }
        }
    }
    
    @ViewBuilder private func WeekRowCell(hasRecord: Bool, isToday: Bool, symbol: String) -> some View {
        
        let sizeRatio: CGFloat = {
            switch (hasRecord, isToday) {
            case (true, _): return 1.0
            case (false, true): return 0.5
            case (false, false): return 0.25
            }
        }()
        
        VStack(spacing: 4) {
            GeometryReader { geo in
                RoundedRectangle(
                    cornerRadius: hasRecord
                    ? geo.size.width * cornerRadiusMultiplier
                    : geo.size.width * sizeRatio / 2
                )
                .fill(
                    LinearGradient(
                        colors: hasRecord || isToday ? [.weekRowCellStart, .weekRowCellEnd] : [.weekRowEmptyCell],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(
                    width: geo.size.width * sizeRatio,
                    height: geo.size.width * sizeRatio
                )
                .position(
                    x: geo.size.width / 2,
                    y: geo.size.width / 2
                )
            }
            .aspectRatio(1, contentMode: .fit)
            
            Text(symbol)
                .frame(height: 14)
                .foregroundStyle(.accent)
                .font(.system(size: 10, weight: .bold))
        }
    }
    
    private func separatorColumn() -> some View {
        VStack(spacing: 4) {
            Capsule()
                .fill(.weekRowSeparator)
                .padding(.vertical, 2)
                .frame(width: 1.5)
            Capsule()
                .fill(.weekRowSeparatorSecondary)
                .frame(width: 1.5, height: 14)
        }
    }
}
