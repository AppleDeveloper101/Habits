//
//  MonthGrid.swift
//  Habits
//
//  Created by Andrey on 28/08/2026.
//

import SwiftUI
import SwiftData

struct MonthGrid: View {
    
    @Query private var records: [Record]
    
    private let model: MonthGridViewModel
    
    init(date: Date, habit: Habit) {
        self.model = MonthGridViewModel(date: date)
        
        let fetchedRecordsHabitID = habit.id
        let fetchInterval = Calendar.current.dateInterval(of: .month, for: date)!
        let predicate = #Predicate<Record> { record in
            record.timestamp >= fetchInterval.start
            && record.timestamp <= fetchInterval.end
            && record.habit?.id == fetchedRecordsHabitID
        }
        
        self._records = Query(filter: predicate)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4.0) {
            Text(model.monthName)
                .foregroundStyle(.accent)
                .lineLimit(1)
                .font(.footnote)
                .fontWeight(.bold)
                .frame(height: 18.0)
            Grid(horizontalSpacing: 2.0, verticalSpacing: 2.0) {
                ForEach(0..<7) { row in
                    GridRow {
                        ForEach(0..<model.columnsCount, id: \.self) { column in
                            let index = row + column * 7
                            
                            let date = Calendar.current.date(
                                byAdding: .day,
                                value: index - model.paddingCellsCount,
                                to: model.normalizedDate
                            )!
                            
                            if !model.validIndexRange.contains(index) {
                                Mark(state: .placeholder)
                            } else if records.contains(where: { Calendar.current.isDate($0.timestamp, inSameDayAs: date) }) {
                                Mark(state: .checked)
                            } else if date.isToday {
                                Mark(state: .today)
                            } else {
                                Mark(state: .unchecked)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct MonthGridViewModel {
    
    let normalizedDate: Date
    let paddingCellsCount: Int
    let monthDaysCount: Int
    let validIndexRange: Range<Int>
    let monthName: String
    let columnsCount: Int
    
    init(date: Date) {
        self.normalizedDate = date.leavingComponents([.calendar, .year, .month])
        
        self.paddingCellsCount = normalizedDate.amountOfPaddingDays
        self.monthDaysCount = Calendar.current.range(
            of: .day,
            in: .month,
            for: normalizedDate
        )!.count
        
        self.validIndexRange = paddingCellsCount..<monthDaysCount+paddingCellsCount
        self.monthName = date.monthName(.wide)
        self.columnsCount = Calendar.current.range(
            of: .weekOfMonth,
            in: .month,
            for: normalizedDate
        )!.count
    }
}

#Preview {
    @Previewable @State var offset = 0
    let habit = Habit(emoji: "🌁", title: "Sample")
    
    var date: Date {
        Calendar.current.date(byAdding: .month, value: offset, to: .now)!
    }
    
    var stepperText: String {
        "Month \(date.formatted(.dateTime.year()))"
    }
    
    VStack(spacing: 32.0) {
        MonthGrid(date: date, habit: habit)
            .frame(height: 320.0)
        Stepper(stepperText, value: $offset)
            .frame(width: 224.0)
    }
    .padding()
}
