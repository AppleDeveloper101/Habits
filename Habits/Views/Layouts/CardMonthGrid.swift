//
//  CardMonthGrid.swift
//  Habits
//
//  Created by Andrey on 23/12/2025.
//

import SwiftUI
import SwiftData

struct CardMonthGrid: View {
    
    // MARK: - Properties
    
    private let date: Date
    private let habit: Habit
    
    @Query private var records: [Record]
    
    @State private var isSheetPresented = false
    
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
    
    // MARK: - Initializers
    
    init(date: Date, habit: Habit) {
        self.date = date
        self.habit = habit
        
        let habitID = habit.persistentModelID
        let predicate = #Predicate<Record> { $0.habit?.persistentModelID == habitID }
        _records = Query(filter: predicate)
    }
    
    // MARK: - Body
    
    var body: some View {
        monthGrid()
            .presentsSheet(presentationState: $isSheetPresented, content: sheetContent)
    }
    
    // MARK: - Subviews
    
    private func monthGrid() -> some View {
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
        .contentShape(.rect)
    }
    
    private var sheetContent: some View {
        CalendarSheet(monthToDisplay: startOfMonth, habit: habit)
    }
}

// MARK: - Modifiers

private extension View {
    func presentsSheet(presentationState: Binding<Bool>, content: some View) -> some View {
        self
            .onTapGesture {
                presentationState.wrappedValue = true
            }
            .sheet(isPresented: presentationState) {
                content
            }
    }
}

// MARK: - Previews

#Preview {
    CardMonthGrid(date: .now, habit: sampleHabit)
        .modelContainer(sampleContainer)
}
