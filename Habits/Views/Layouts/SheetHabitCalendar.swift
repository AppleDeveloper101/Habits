//
//  SheetHabitCalendar.swift
//  Habits
//
//  Created by Andrey on 08/01/2026.
//

import SwiftUI

struct SheetHabitCalendar: View {
    
    // MARK: - Properties
    
    private let monthToDisplay: Date
    private let habit: Habit
    
    private let columnToGridSpacing: CGFloat = 8
    private let gridToGridSpacing: CGFloat = 16
    
    // MARK: - Initializer
    
    init(monthToDisplay: Date, habit: Habit) {
        self.monthToDisplay = monthToDisplay
        self.habit = habit
    }
    
    // MARK: - Body
    
    var body: some View {
        calendar()
    }
    
    // MARK: - Subviews
    
    private func calendar() -> some View {
        HStack(alignment: .bottom, spacing: .zero) {
            SheetWeekdaysColumn()
            MonthGrids()
        }
    }
    
    private func MonthGrids() -> some View {
        ScrollView(.horizontal) {
            HStack(spacing: gridToGridSpacing) {
                // TODO: Infinite scroll
                SheetMonthGrid(date: monthToDisplay, habit: habit)
            }
            .padding(.leading, columnToGridSpacing)
        }
        .scrollIndicators(.hidden)
        .scrollClipDisabled()
        .columnMask()
    }
}

// MARK: - Modifiers

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

// MARK: - Previews

#if DEBUG
import SwiftData

#Preview {
    SheetHabitCalendar(monthToDisplay: .now, habit: sampleHabit)
        .padding(.leading)
        .modelContainer(sampleContainer)
}
#endif
