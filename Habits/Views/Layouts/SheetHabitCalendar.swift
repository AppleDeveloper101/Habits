//
//  SheetHabitCalendar.swift
//  Habits
//
//  Created by Andrey on 08/01/2026.
//

// TODO: Programmatic scrolling – focused month selection

import SwiftUI

struct SheetHabitCalendar: View {
    
    // MARK: Properties
    
    private let monthsToDisplay: [Date]
    private let habit: Habit
    
    private let columnToGridSpacing: CGFloat = 8
    private let gridToGridSpacing: CGFloat = 16
    
    // MARK: Initializer
    
    init(monthsToDisplay: [Date], habit: Habit) {
        self.monthsToDisplay = monthsToDisplay
        self.habit = habit
    }
    
    // MARK: Body
    
    var body: some View {
        HStack(alignment: .bottom, spacing: .zero) {
            SheetWeekdaysColumn()
            MonthGrids()
        }
    }
    
    // MARK: Subviews
    
    private func MonthGrids() -> some View {
        ScrollView(.horizontal) {
            HStack(spacing: gridToGridSpacing) {
                ForEach(monthsToDisplay, id: \.self) { month in
                    SheetMonthGrid(date: month, habit: habit)
                }
            }
            .padding(.leading, columnToGridSpacing)
        }
        .scrollIndicators(.hidden)
        .scrollClipDisabled()
        .columnMask()
    }
}

// MARK: Modifiers

private extension View {
    func columnMask() -> some View {
        self
            .mask {
                VStack(spacing: 0) {
                    Rectangle()
                        .frame(height: SheetMonthHeader.height)
                        .containerRelativeFrame(.horizontal) { size, _ in
                            size * 2 // Ensure month headers visible across full screen width
                        }
                    Rectangle()
                }
            }
    }
}

// TODO: Rewrite

#if DEBUG
import SwiftData

#Preview {
    let months = (-1...1).map { offset in
        Calendar.current.date(byAdding: .month, value: offset, to: .now) ?? .now
    }
    
    SheetHabitCalendar(monthsToDisplay: months, habit: sampleHabit)
        .padding(.leading)
        .modelContainer(sampleContainer)
}
#endif
