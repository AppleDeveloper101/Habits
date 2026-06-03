//
//  CalendarSheetHeader.swift
//  Habits
//
//  Created by Andrey on 03/06/2026.
//

import SwiftUI

struct CalendarSheetHeader: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    private let habit: Habit
    
    init(habit: Habit) {
        self.habit = habit
    }
    
    var body: some View {
        HStack {
            HStack(spacing: 4) {
                Text(habit.emoji.isEmpty ? "🎯" : habit.emoji)
                    .fixedSize()
                    .font(.system(size: 34, weight: .regular))
                    .frame(width: 34, height: 34)
                    .saturation(habit.emoji.isEmpty ? 0 : 1)
                    .contrast(habit.emoji.isEmpty ? 1.17 : 1)
                    .brightness(!habit.emoji.isEmpty && colorScheme == .dark  ? -0.14 : 0)
                Text(habit.title)
                    .font(.title3.bold())
                    .foregroundStyle(.accent)
            }
            
            Spacer()
            
            Button {
                ModalManager.shared.dismiss()
            } label: {
                Text("Done")
                    .font(.body.bold())
                    .frame(height: 44)
                    .padding(.horizontal, 16)
                    .foregroundStyle(.complementary)
                    .background(.accent, in: .capsule)
            }
        }
    }
}

#Preview {
    CalendarSheetHeader(habit: .init(emoji: "🥝", title: "Kiwi"))
        .padding(.horizontal, 32)
}
