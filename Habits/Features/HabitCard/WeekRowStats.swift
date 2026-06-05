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
    
    private let calendar = Calendar.current
    
    private var datesRange: [Date] {
        var dates: [Date] = []
        let startOfCurrentWeek = calendar.dateInterval(of: .weekOfYear, for: .now)!.start
        let weekRowLastDate = calendar.date(byAdding: .day, value: 6, to: startOfCurrentWeek)!
        
        (0..<10).reversed().forEach { index in
            let dateToAdd = calendar.date(byAdding: .day, value: -index, to: weekRowLastDate)!
            dates.append(dateToAdd)
        }
        
        return dates
    }
    
    init(habit: Habit) {
        self.habit = habit
        
        let fetchedRecordsHabitID = habit.persistentModelID
        
        let predicate = #Predicate<Record> {
            $0.habit?.persistentModelID == fetchedRecordsHabitID
        }
        
        self._records = Query(filter: predicate, sort: \.timestamp)
    }
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(Array(datesRange.enumerated()), id: \.offset) { index, date in
                WeekRowCell(
                    hasRecord: records.contains { calendar.isDate($0.timestamp, equalTo: date, toGranularity: .day) },
                    isToday: calendar.isDate(date, equalTo: .now, toGranularity: .day),
                    symbol: date.formatted(.dateTime.weekday(.narrow))
                )
                if index == 2 { separatorColumn() }
            }
        }
        .contentShape(.rect)
        .onTapGesture {
            ModalManager.shared.present(.habitCalendarSheet(habit, .now))
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
