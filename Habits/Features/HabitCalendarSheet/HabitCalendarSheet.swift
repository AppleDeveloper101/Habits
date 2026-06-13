//
//  HabitCalendarSheet.swift
//  Habits
//
//  Created by Andrey on 04/06/2026.
//

import SwiftUI
import SwiftData

// TODO: Refactor, optimize performance if possible

struct HabitCalendarSheet: View {
    
    @Query private var records: [Record]
    
    private let habit: Habit
    private let date: Date
    
    @State private var focusedMonth: Date?
    
    @State private var monthGridHeaderHeight: CGFloat = .zero
    
    private let calendar = Calendar.current
    
    private let scrollFixPadding: CGFloat = 999_999
    
    private var firstDisplayedMonth: Date {
        if let firstRecordDate = records.first?.timestamp {
            let firstRecordMonth = calendar.dateInterval(of: .month, for: firstRecordDate)!.start
            return min(firstRecordMonth, initiallyPresentedMonth)
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
                    .padding(.bottom, 16)
                
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
                                        HabitCalendarGridCell(
                                            date: dayDate,
                                            hasRecord: records.contains { calendar.isDate($0.timestamp, inSameDayAs: dayDate) },
                                            isToday: calendar.isDate(dayDate, inSameDayAs: .startOfToday),
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
                    .padding(.bottom, 16)
                    .padding(.bottom, scrollFixPadding)
                }
                .padding(.bottom, -scrollFixPadding)
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
                .padding(.trailing, -16)
            }
        }
        .padding([.leading, .trailing, .top], 16)
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
}

struct HabitCalendarGridCell: View {
    let date: Date
    let hasRecord: Bool
    let isToday: Bool
    let isDisabled: Bool
    let habit: Habit
    
    @State private var isBackgroundFilled: Bool
    @State private var visualHasRecord: Bool
    @State private var isAwaitingDelay = false
    
    @State private var animationOffset: CGFloat = 0.0
    @State private var scaleX: CGFloat = 0.0
    @State private var scaleY: CGFloat = 0.0
    
    @State private var textScale: CGFloat = 1.0
    @State private var indicatorColor: Color = .clear
    
    init(date: Date, hasRecord: Bool, isToday: Bool, isDisabled: Bool, habit: Habit) {
        self.date = date
        self.hasRecord = hasRecord
        self.isToday = isToday
        self.isDisabled = isDisabled
        self.habit = habit
        self._visualHasRecord = State(initialValue: hasRecord)
        self._isBackgroundFilled = State(initialValue: hasRecord)
    }
    
    var body: some View {
        let indicatorWidth: CGFloat = visualHasRecord ? 16.0 : 6.0
        let indicatorHeight: CGFloat = visualHasRecord ? 4.0 : 6.0
        let cellFillColor: Color = .accent
        
        Text(date.formatted(.dateTime.day(.defaultDigits)))
            .fixedSize()
            .font(.title3.bold())
            .scaleEffect(textScale, anchor: .center)
            .onChange(of: isBackgroundFilled) { _, willFill in
                if willFill {
                    Task {
                        try? await Task.sleep(for: .seconds(isToday ? 0.3 : 0.2))
                        withAnimation(.spring(duration: 0.2)) {
                            textScale = 1.15
                        }
                        try? await Task.sleep(for: .seconds(0.2))
                        withAnimation(.spring(duration: 0.2)) {
                            textScale = 1.0
                        }
                    }
                }
            }
            .foregroundStyle(
                isBackgroundFilled ? .complementary
                : isDisabled ? .sheetCalendarGridCellDisabled : .accent
            )
            .overlay(alignment: .bottom) {
                if isToday {
                    Capsule()
                        .fill(indicatorColor)
                        .frame(width: indicatorWidth, height: indicatorHeight)
                        .animation(.spring(duration: 0.4, bounce: visualHasRecord ? 0.5 : 0.4), value: indicatorWidth)
                        .offset(y: indicatorHeight + 0.5)
                        .onChange(of: isBackgroundFilled) { _, willFill in
                            Task {
                                try? await Task.sleep(for: .seconds(willFill ? 0.3 : 0.15))
                                indicatorColor = willFill ? .complementary : .accent
                            }
                        }
                        .onAppear {
                            indicatorColor = isBackgroundFilled ? .complementary : .accent
                        }
                }
            }
            .frame(width: 44, height: 44)
            .background {
                RoundedRectangle(cornerRadius: 44 * 0.34375)
                    .foregroundStyle(cellFillColor)
                    .scaleEffect(x: scaleX, y: scaleY, anchor: .bottom)
                    .animation(.smooth, value: isBackgroundFilled)
                    .offset(y: animationOffset)
                    .onChange(of: isBackgroundFilled) { _, willFill in
                        Task {
                            withAnimation(isBackgroundFilled ? .spring(.bouncy) : .smooth) {
                                scaleX = isBackgroundFilled ? 1.0 : 0.0
                                scaleY = scaleX
                            }
                            if isToday {
                                withAnimation(.spring) {
                                    animationOffset = willFill ? -20 : 20
                                }
                                try? await Task.sleep(for: .seconds(0.2))
                                withAnimation(.spring(duration: 0.3, bounce: willFill ? 0.5 : 0.3)) {
                                    animationOffset = willFill ? 0 : -4
                                }
                            }
                        }
                    }
                    .onAppear {
                        animationOffset = isToday && !hasRecord ? -4 : 0
                        scaleX = isBackgroundFilled ? 1.0 : 0.0
                        scaleY = scaleX
                    }
            }
            .animation(.smooth, value: visualHasRecord)
            .onTapGesture {
                guard !isDisabled else { return }
                guard !isAwaitingDelay else { return }
                
                DataManager.shared.toggleRecord(for: habit, on: date)
                
                isAwaitingDelay = true
                
                Task {
                    withAnimation(.smooth(duration: 0.35)) {
                        isBackgroundFilled.toggle()
                    }
                    
                    try? await Task.sleep(for: .seconds(0.35))
                    
                    withAnimation(.smooth) {
                        visualHasRecord.toggle()
                    } completion: {
                        isAwaitingDelay = false
                    }
                }
            }
            .onChange(of: hasRecord) { _, newValue in
                if !isAwaitingDelay {
                    visualHasRecord = newValue
                }
            }
    }
}
