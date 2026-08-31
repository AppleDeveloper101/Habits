//
//  HabitCalendarSheet.swift
//  Habits
//
//  Created by Andrey on 04/06/2026.
//

import SwiftUI
import SwiftData

// TODO: Refactor, optimize performance

struct HabitCalendarSheet: View {
    
    @Query private var records: [Record]
    
    private let habit: Habit
    private let date: Date
    
    @State private var focusedMonth: Date?
    
    @State private var monthGridHeaderHeight: CGFloat = .zero
    
    private let calendar = Calendar.current
    
    private var firstDisplayedMonth: Date {
        if let firstRecordDate = records.first?.timestamp {
            let firstRecordMonth = calendar.dateInterval(of: .month, for: firstRecordDate)!.start
            let habitCreationMonth = calendar.dateInterval(of: .month, for: habit.timestamp)!.start
            return min(initiallyPresentedMonth, min(firstRecordMonth, habitCreationMonth))
        } else {
            let habitCreationMonth = calendar.dateInterval(of: .month, for: habit.timestamp)!.start
            return min(habitCreationMonth, initiallyPresentedMonth)
        }
    }
    
    private var lastDisplayedMonth: Date {
        calendar.dateInterval(of: .month, for: .now)!.start
    }
    
    private var initiallyPresentedMonth: Date {
        calendar.dateInterval(of: .month, for: date)!.start
    }
    
    private var displayedMonths: [Date] {
        var months: [Date] = []
        var dateToAdd = firstDisplayedMonth
        
        while dateToAdd <= lastDisplayedMonth {
            months.append(dateToAdd)
            dateToAdd = calendar.date(byAdding: .month, value: 1, to: dateToAdd)!
        }
        
        return months
    }
    
    var daysSinceHabitCreation: Int {
        let components = calendar.dateComponents(
            [.day],
            from: calendar.dateInterval(of: .day, for: habit.timestamp)!.start,
            to: calendar.dateInterval(of: .day, for: .now)!.end
        )
        return components.day!
    }
    
    var acceptance: Double { Double(records.count) / Double(daysSinceHabitCreation) * 100 }
    
    private var metrics: [FooterMetric] {
        return [
            FooterMetric(
                header: "Duration",
                metric: "^[\(daysSinceHabitCreation) day](inflect:true)",
                imageSystemName: "calendar",
            ),
            FooterMetric(
                header: "Contribution",
                metric: "^[\(records.count) Check-In](inflect:true)",
                imageSystemName: "square.grid.2x2.fill",
            ),
            FooterMetric(
                header: "Acceptance",
                metric: "\(acceptance.formatted(.number.precision(.fractionLength(0...1))))",
                imageSystemName: "percent",
                metricToImageSpacing: 0.0
            )
        ]
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
        VStack(spacing: .zero) {
            CalendarSheetHeader(habit: habit)
                .padding(16.0)
            
            HStack(alignment: .bottom, spacing: .zero) {
                weekdaysColumn()
                
                ScrollView(.horizontal) {
                    scrollViewContent()
                }
                .scrollClipDisabled()
                .scrollIndicators(.hidden)
                .scrollPosition(id: $focusedMonth, anchor: .leading)
                .onAppear { focusedMonth = initiallyPresentedMonth }
                .mask {
                    VStack(spacing: .zero) {
                        Rectangle()
                            .frame(width: 999_999, height: monthGridHeaderHeight)
                        Rectangle()
                    }
                }
            }
            .padding(.leading, 16)
            
            CalendarSheetFooter(metrics)
                .padding(.init(top: 12.0, leading: 32.0, bottom: 16.0, trailing: 16.0))
        }
        .persistentSystemOverlays(.hidden)
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
    
    private func placeHolderCell() -> some View {
        Color.clear.frame(width: 44, height: 44)
    }
    
    private func scrollViewContent() -> some View {
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
                    .readSize(.vertical, into: $monthGridHeaderHeight)
                    
                    LazyHGrid(rows: Array(repeating: GridItem(spacing: 8), count: 7), spacing: 8) {
                        ForEach(0..<month.amountOfPaddingDays, id: \.self) { _ in
                            placeHolderCell()
                        }
                        ForEach(month.monthDaysRange, id: \.self) { dayDate in
                            CalendarSheetGridCell(
                                date: dayDate,
                                hasRecord: records.contains { calendar.isDate($0.timestamp, inSameDayAs: dayDate) },
                                isToday: dayDate.isToday,
                                isDisabled: dayDate > .startOfToday || dayDate < calendar.startOfDay(for: habit.timestamp),
                                habit: habit
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
}

#Preview {
    Color.clear
        .modalPresenter()
        .ignoresSafeArea()
        .contentShape(.rect)
        .onTapGesture {
            ModalManager.shared.present(.habitCalendarSheet(.init(emoji: "S", title: "Sample"), .now))
        }
        .task {
            ModalManager.shared.present(.habitCalendarSheet(.init(emoji: "S", title: "Sample"), .now))
        }
}
