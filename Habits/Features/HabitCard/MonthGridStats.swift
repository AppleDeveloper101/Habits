//
//  MonthGridStats.swift
//  Habits
//
//  Created by Andrey on 05/08/2026.
//

import SwiftUI
import SwiftData

// TODO: Conduct architectural changes

struct MonthGridStats: View {
    
    @Query private var records: [Record]
    
    @State private var width: CGFloat = 0.0
    @State private var gridHeight: CGFloat = 0.0
    
    let habit: Habit
    
    let weekdaysToGridsSpacing: CGFloat = 4.0
    let monthHeaderToGridSpacing: CGFloat = 4.0
    let gridSpacing: CGFloat = 8.0
    let cellSpacing: CGFloat = 2.0
    
    var gridModels = (-2...0).map { offset in
        let currentMonth = Calendar.current.dateComponents([.calendar, .year, .month], from: .now).date!
        let date = Calendar.current.date(byAdding: .month, value: offset, to: currentMonth)!
        return MonthGridModel(date: date)
    }
    
    var datesWithRecords: Set<Date> {
        let gridDates = gridModels.reduce([]) { accumulator, model in
            accumulator + model.dates
        }
        let recordDates = records.map { record in
            Calendar.current.dateComponents([.calendar, .day, .month, .year], from: record.timestamp).date!
        }
        let allDates: Set<Date> = Set(gridDates)
        let allRecordDates: Set<Date> = Set(recordDates)
        return allDates.intersection(allRecordDates)
    }
    
    var columnWidth: CGFloat {
        let totalColumnsCount = gridModels.reduce(0) { $0 + $1.columnCount }
        let gridGaps = gridModels.count - 1
        let cellGaps = totalColumnsCount - gridModels.count
        let leanWidth = width - CGFloat(cellGaps) * cellSpacing - CGFloat(gridGaps) * gridSpacing
        return leanWidth / CGFloat(totalColumnsCount)
    }
    
    init(habit: Habit) {
        self.habit = habit
        
        let fetchedRecordsHabitID = habit.id
        let predicate = #Predicate<Record> {
            $0.habit?.id == fetchedRecordsHabitID
        }
        
        _records = Query(filter: predicate)
    }
    
    var body: some View {
        HStack(alignment: .bottom, spacing: weekdaysToGridsSpacing) {
            weekdaysColumn()
                .frame(height: gridHeight)
            HStack(spacing: gridSpacing) {
                ForEach(gridModels) { model in
                    VStack(alignment: .leading, spacing: monthHeaderToGridSpacing) {
                        header(date: model.date)
                        grid(model: model)
                            .readHeight(into: $gridHeight)
                    }
                    .contentShape(.rect)
                    .onTapGesture {
                        ModalManager.shared.present(.habitCalendarSheet(habit, model.date))
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .readWidth(into: $width)
        }
    }
    
    @ViewBuilder private func weekdaysColumn() -> some View {
        
        let firstWeekday = Calendar.current.firstWeekday - 1
        let shortSymbols = Calendar.current.veryShortWeekdaySymbols
        let symbols = shortSymbols[firstWeekday...] + shortSymbols[..<firstWeekday]
        
        HStack(spacing: 1.0) {
            VStack(spacing: cellSpacing) {
                ForEach(symbols, id: \.self) { symbol in
                    Text(symbol)
                        .foregroundStyle(.accent)
                        .font(.system(size: 9))
                        .fontWeight(.semibold)
                        .frame(height: columnWidth)
                }
            }
            .frame(width: 16.0)
            Capsule()
                .fill(.monthGridStatsWeekdaysColumnSeparator)
                .frame(width: 1.0)
        }
    }
    
    @ViewBuilder private func header(date: Date) -> some View {
        Text(date.formatted(.dateTime.month(.wide)))
            .foregroundStyle(.accent)
            .font(.system(size: 14))
            .fontWeight(.semibold)
            .lineLimit(1)
    }
    
    @ViewBuilder private func grid(model: MonthGridModel) -> some View {
        HStack(spacing: cellSpacing) {
            ForEach(0..<model.columnCount, id: \.self) { column in
                VStack(spacing: cellSpacing) {
                    ForEach(0..<7) { row in
                        let cellNumber = (column * 7 + row + 1)
                        let dateIndex = 0 - model.paddingCellsCount + cellNumber - 1
                        
                        if model.dates.indices.contains(dateIndex) {
                            if datesWithRecords.contains(model.dates[dateIndex]) {
                                Mark(state: .checked)
                            } else if model.dates[dateIndex].isToday {
                                Mark(state: .today)
                            } else {
                                Mark()
                            }
                        } else {
                            Mark(state: .placeholder)
                        }
                    }
                }
                .frame(width: columnWidth) // FIXME: Runtime freeze upon creation, fixed by applying to cells directly
            }
        }
    }
    
}

struct MonthGridModel: Identifiable {
    
    let id: UUID
    let date: Date
    let dates: [Date]
    let columnCount: Int
    let paddingCellsCount: Int
    
    init(date: Date = .now) {
        self.id = UUID()
        self.date = Calendar.current.dateComponents([.calendar, .year, .month], from: date).date!
        self.dates = {
            let range = Calendar.current.range(of: .day, in: .month, for: date)!
            return range.map { offset in Calendar.current.date(byAdding: .day, value: offset - 1, to: date)! }
        }()
        self.columnCount = Calendar.current.range(of: .weekOfYear, in: .month, for: date)!.count
        self.paddingCellsCount = {
            let currentMonth = Calendar.current.dateComponents([.calendar, .year, .month], from: date).date!
            let firstWeekday = Calendar.current.firstWeekday
            let monthWeekday = Calendar.current.component(.weekday, from: currentMonth)
            return (monthWeekday - firstWeekday + 7) % 7
        }()
    }
    
}

#Preview {
    let habit = Habit(emoji: "🌁", title: "Preview Habit")
    
    ScrollView {
        VStack(spacing: 8) {
            CardHeader(habit)
            MonthGridStats(habit: habit)
        }
        .padding(12)
        .background(DefaultStyleShape(RoundedRectangle(cornerRadius: 24), isElevated: true))
        .padding()
    }
}
