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
        .backgroundWithStroke(shape: cardShape)
        .contentShape(.contextMenuPreview, cardShape)
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

struct HabitCardContextMenu: ViewModifier {
    @Environment(\.modelContext) private var context
    
    let habit: Habit
    
    func body(content: Content) -> some View {
        content
            .contextMenu {
                Button("Delete", systemImage: "trash", role: .destructive) {
                    context.delete(habit)
                    
                    if context.hasChanges { do { try context.save() } catch {
                        fatalError("Failed to save persistent storage after deleting a habit") }
                    }
                }
            }
    }
}

extension View {
    func habitCardContextMenu(habit: Habit) -> some View {
        modifier(HabitCardContextMenu(habit: habit))
    }
}

#if DEBUG

import SwiftData

#Preview {
    HabitCard(habit: Habit.sample)
        .modelContainer(sampleContainer)
        .padding()
}
#endif
