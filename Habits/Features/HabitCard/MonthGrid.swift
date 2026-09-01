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
    
    init(month date: Date, habit: Habit) {
        self.model = MonthGridViewModel(date: date)
        
        let habitID = habit.id
        let timeInterval = model.monthDate.interval(of: .month)
        let predicate = #Predicate<Record> { record in
            record.habit?.id == habitID
            && record.timestamp >= timeInterval.start
            && record.timestamp < timeInterval.end
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
                                to: model.monthDate
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
    
    let monthDate: Date
    let daysCount: Int
    let columnsCount: Int
    let paddingCellsCount: Int
    let validIndexRange: Range<Int>
    let monthName: String
    
    init(date: Date) {
        self.monthDate = date.leavingComponents([.calendar, .year, .month])
        self.daysCount = monthDate.count(of: .day, in: .month)
        self.columnsCount = monthDate.count(of: .weekOfMonth, in: .month)
        self.paddingCellsCount = monthDate.amountOfPaddingDays
        self.validIndexRange = paddingCellsCount..<daysCount+paddingCellsCount
        self.monthName = date.monthName(.wide)
    }
}

#Preview {
    @Previewable @State var offset = 0
    let habit = Habit(emoji: "🌁", title: "Sample")
    
    var date: Date {
        Calendar.current.date(byAdding: .month, value: offset, to: .now)!
    }
    
    var stepperText: String {
        "\(date.formatted(.dateTime.month(.wide))) \(date.formatted(.dateTime.year()))"
    }
    
    VStack(spacing: 32.0) {
        MonthGrid(month: date, habit: habit)
            .frame(height: 192.0)
        Stepper(stepperText, value: $offset)
            .frame(width: 240.0)
    }
}
