//
//  HabitCard.swift
//  Habits
//
//  Created by Andrey on 24/12/2025.
//

import SwiftUI

struct HabitCard: View {
    private let habit: Habit
    
    private let headerToCalendarSpacing: CGFloat = 8
    
    private let outerPadding: CGFloat = 12
    
    private let cardShape = RoundedRectangle(cornerRadius: 24)
    
    init(habit: Habit) {
        self.habit = habit
    }
    
    var body: some View {
        VStack(spacing: headerToCalendarSpacing) {
            CardHeader(habit: habit)
                .padding(.trailing, outerPadding)
            
            ScrollView(.horizontal) {
                CardHabitCalendar(displayedMonths: monthsToDisplay(), habit: habit)
            }
            .scrollDisabled(true)
        }
        .padding([.leading, .top, .bottom], outerPadding)
        
        // Use of paddings addressed to fix visual bug caused by
        // non-obvious misalignment between clipShape and strokeBorder,
        // which causes text to bleed through clipping shape on pixel-precision level
        .padding(.trailing, -0.5)
        .clipShape(cardShape)
        .padding(.trailing, 0.5)
        
        .background {
            cardShape
                .fill(.background)
                .shadow(color: .black.opacity(0.10), radius: 14, y: 4)
        }
        .overlay {
            cardShape
                .strokeBorder(lineWidth: 1)
                .foregroundStyle(Color(hue: 0, saturation: 0, brightness: 0.84))
        }
    }
}

// TODO: Implement logic, remove

private func monthsToDisplay() -> [Date] {
    let calendar = Calendar.current
    var displayedMonths: [Date] {
        guard let startOfFirstDisplayedMonth = calendar.dateInterval(of: .month, for: .now)?.start else {
            fatalError("Failed to retrieve startOfFirstShownMonth in CardHabitCalendar")
        }
        
        return (-1..<4).map { offset in
            guard let date = calendar.date(byAdding: .month, value: offset, to: startOfFirstDisplayedMonth) else {
                fatalError("Failed to retrieve date in CardHabitCalendar")
            }
            return date
        }
    }
    return displayedMonths
}

#if DEBUG

import SwiftData

#Preview(traits: .sizeThatFitsLayout) {
    VStack(spacing: 16) {
        HabitCard(habit: SampleData.shared.sampleHabit)
        HabitCard(habit: SampleData.shared.sampleHabit)
    }
    .padding()
    .modelContainer(SampleData.shared.container)
}
#endif
