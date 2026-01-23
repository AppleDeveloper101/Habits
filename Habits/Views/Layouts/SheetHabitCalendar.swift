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
    
    @State private var focusedMonth: Date?
    @State private var months: [Date] = []
    
    private var startOfMonthToDisplay: Date {
        let calendar = Calendar.current
        
        guard let startOfMonth = calendar.dateInterval(of: .month, for: monthToDisplay)?.start else {
            assertionFailure("Failed to obtain startOfMonthToDisplay in SheetHabitCalendar")
            return .now
        }
        
        return startOfMonth
    }
    
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
                ForEach(months, id: \.self) { month in
                    SheetMonthGrid(date: month, habit: habit)
                        .id(month)
                }
            }
            .padding(.horizontal, columnToGridSpacing)
        }
        .scrollTargetLayout()
        .defaultScrollAnchor(.trailing)
        .scrollPosition(id: $focusedMonth)
        .scrollIndicators(.hidden)
        .scrollClipDisabled()
        .columnMask()
        .onAppear {
            loadInitialMonths()
            focusedMonth = startOfMonthToDisplay
        }
    }
    
    // MARK: - Helpers
    
    private func loadInitialMonths() {
        guard months.isEmpty else { return }
        
        let calendar = Calendar.current
        
        for offset in -1...1 {
            if let month = calendar.date(byAdding: .month, value: offset, to: startOfMonthToDisplay) {
                months.append(month)
            }
        }
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
