//
//  CalendarSheet.swift
//  Habits
//
//  Created by Andrey on 09/01/2026.
//

import SwiftUI

struct CalendarSheet: View {
    
    // MARK: - Properties
    
    private let monthToDisplay: Date
    private let habit: Habit
    
    @State private var detentHeight: CGFloat = .zero
    
    private let headerToCalendarSpacing: CGFloat = 32
    
    // MARK: - Initializers
    
    init(monthToDisplay: Date, habit: Habit) {
        self.monthToDisplay = monthToDisplay
        self.habit = habit
    }
    
    // MARK: - Body
    
    var body: some View {
        sheetContent()
            .setHeight(for: $detentHeight)
            .layoutSheetContent(detentHeight: detentHeight)
    }
    
    // MARK: - Subviews
    
    private func sheetContent() -> some View {
        VStack(spacing: headerToCalendarSpacing) {
            SheetHeader(habit: habit)
                .padding([.leading, .top, .trailing])
            SheetHabitCalendar(monthsToDisplay: [monthToDisplay], habit: habit)
                .padding([.leading, .bottom])
        }
    }
}

// MARK: - Modifiers

private extension View {
    func setHeight(for property: Binding<CGFloat>) -> some View {
        self
            .overlay {
                GeometryReader { proxy in
                    Color.clear
                        .onGeometryChange(for: CGFloat.self) { proxy in
                            proxy.size.height
                        } action: { newHeight in
                            property.wrappedValue = newHeight
                        }
                }
            }
    }
}

private extension View {
    func layoutSheetContent(detentHeight: CGFloat) -> some View {
        self
            .frame(maxHeight: .infinity, alignment: .top)
            .presentationDetents([.height(detentHeight)])
    }
}

// MARK: - Previews

#if DEBUG
import SwiftData

#Preview {
    @Previewable @State var isPresented = true
    
    Color(.systemBackground)
        .onTapGesture {
            isPresented = true
        }
        .sheet(isPresented: $isPresented) {
            CalendarSheet(monthToDisplay: .now, habit: sampleHabit)
                .modelContainer(sampleContainer)
        }
}
#endif
