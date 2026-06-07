//
//  HabitCalendarSheet.swift
//  Habits
//
//  Created by Andrey on 04/06/2026.
//

import SwiftUI
import SwiftData

// TODO: Refactor

struct HabitCalendarSheet: View {
    
    @Query private var records: [Record]
    
    private let habit: Habit
    private let date: Date
    
    @State private var focusedMonth: Date?
    
    @State private var monthGridHeaderHeight: CGFloat = .zero
    
    private let calendar = Calendar.current
    
    private var firstMonthContainingRecord: Date {
        guard let fistRecordDate = records.first?.timestamp else {
            return calendar.dateInterval(of: .month, for: habit.timestamp)!.start
        }
        return calendar.dateInterval(of: .month, for: fistRecordDate)!.start
    }
    
    private var lastMonthContainingRecord: Date {
        guard let lastRecordDate = records.last?.timestamp else {
            return calendar.dateInterval(of: .month, for: .now)!.start
        }
        return calendar.dateInterval(of: .month, for: lastRecordDate)!.start
    }
    
    private var displayedMonths: [Date] {
        var months: [Date] = []
        var dateToAdd = firstMonthContainingRecord
        
        while dateToAdd <= lastMonthContainingRecord {
            months.append(dateToAdd)
            dateToAdd = calendar.date(byAdding: .month, value: 1, to: dateToAdd)!
        }
        
        return months
    }
    
    init(habit: Habit, date: Date) {
        self.habit = habit
        self.date = date
        self.focusedMonth = calendar.date(from: calendar.dateComponents([.month, .year], from: date))!
        
        let fetchedRecordsHabitID = habit.persistentModelID
        
        let predicate = #Predicate<Record> {
            $0.habit?.persistentModelID == fetchedRecordsHabitID
        }
        
        self._records = Query(filter: predicate, sort: \.timestamp)
    }
    
    var body: some View {
        VStack(spacing: 32) {
            CalendarSheetHeader(habit: habit)
            
            HStack(alignment: .bottom, spacing: .zero) {
                weekdaysColumn()
                
                ScrollView(.horizontal) {
                    HStack(alignment: .bottom, spacing: .zero) {
                        ForEach(displayedMonths, id: \.self) { month in
                            VStack(spacing: 8) {
                                HStack(alignment: .firstTextBaseline, spacing: 8) {
                                    Text(month.formatted(.dateTime.month(.wide)))
                                        .font(.title.bold())
                                        .foregroundStyle(.accent)
                                    if !calendar.isDate(month, equalTo: .now, toGranularity: .year) {
                                        Text(month.formatted(.dateTime.year(.defaultDigits)))
                                            .font(.title3.bold())
                                            .foregroundStyle(.accentFaded)
                                    }
                                    Spacer()
                                }
                                .padding(.horizontal, 16 / 2)
                                .readHeight(into: $monthGridHeaderHeight)
                                
                                LazyHGrid(rows: Array(repeating: GridItem(spacing: 8), count: 7), spacing: 8) {
                                    ForEach(0..<month.amountOfPaddingDays, id: \.self) { _ in
                                        placeHolderCell()
                                    }
                                    ForEach(month.monthDaysRange, id: \.self) { dayDate in
                                        calendarGridCell(
                                            date: dayDate,
                                            hasRecord: records.contains { calendar.isDate($0.timestamp, inSameDayAs: dayDate) },
                                            isToday: calendar.isDate(dayDate, inSameDayAs: .startOfToday),
                                            isDisabled: dayDate > .startOfToday || dayDate < calendar.startOfDay(for: habit.timestamp)
                                        )
                                    }
                                }
                                .fixedSize()
                                .padding(.horizontal, 16 / 2)
                                .containerRelativeFrame(
                                    .horizontal,
                                    count: month == displayedMonths.last ? 1 : 0,
                                    spacing: .zero,
                                    alignment: .leading,
                                )
                            }
                            .id(month)
                        }
                    }
                }
                .scrollClipDisabled()
                .scrollIndicators(.hidden)
                .scrollPosition(id: $focusedMonth, anchor: .leading)
                .onAppear { focusedMonth = displayedMonths.last }
                .mask {
                    VStack(spacing: .zero) {
                        Rectangle()
                            .frame(width: 999_999, height: monthGridHeaderHeight)
                        Rectangle()
                    }
                }
                .padding(.trailing, -16)
            }
        }
        .padding(16)
    }
    
    @ViewBuilder private func weekdaysColumn() -> some View {
        
        let symbols = calendar.veryShortWeekdaySymbols
        let systemFirstWeekdayIndex = calendar.firstWeekday - 1
        var weekdays: [String] { Array(symbols[systemFirstWeekdayIndex...]) + Array(symbols[..<systemFirstWeekdayIndex]) }
        
        HStack(spacing: 6) {
            VStack(spacing: 8) {
                ForEach(weekdays, id: \.self) { symbol in
                    Text(symbol)
                        .font(.title3.bold())
                        .foregroundStyle(.sheetCalendarWeekdaySymbol)
                        .frame(width: 22, height: 44)
                }
            }
            
            Capsule()
                .fill(.sheetWeekdaysColumnSeparator)
                .frame(width: 2)
        }
        .fixedSize()
    }
    
    private func calendarGridCell(date: Date, hasRecord: Bool, isToday: Bool, isDisabled: Bool) -> some View {
        Text(date.formatted(.dateTime.day(.defaultDigits)))
            .font(.title3.bold())
            .foregroundStyle(
                hasRecord ? .complementary
                : isDisabled ? .sheetCalendarGridCellDisabled : .accent
            )
            .frame(width: 44, height: 44)
            .background {
                RoundedRectangle(cornerRadius: 44 * 0.34375)
                    .foregroundStyle(hasRecord ? .accent : .clear)
                    .overlay {
                        RoundedRectangle(cornerRadius: 44 * 0.34375).strokeBorder(!hasRecord && isToday ? .accent : .clear, lineWidth: 2)
                    }
            }
            .overlay(alignment: .bottom) {
                if hasRecord && isToday {
                    Capsule()
                        .offset(y: -5)
                        .fill(.complementary)
                        .frame(width: 16, height: 4)
                }
            }
            .onTapGesture {
                guard !isDisabled else { return }
                DataManager.shared.toggleRecord(for: habit, on: date)
            }
    }
    
    private func placeHolderCell() -> some View {
        Color.clear.frame(width: 44, height: 44)
    }
}
