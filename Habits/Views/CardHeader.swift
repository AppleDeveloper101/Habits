//
//  CardHeader.swift
//  Habits
//
//  Created by Andrey on 24/12/2025.
//

import SwiftUI

struct CardHeader: View {
    private let habit: Habit
    
    init(habit: Habit) {
        self.habit = habit
    }
    
    private let emojiToTitleSpacing: CGFloat = 4
    
    var body: some View {
        HStack {
            HStack(spacing: emojiToTitleSpacing) {
                Text(habit.emoji)
                    .font(.system(size: 34))
                    .frame(width: 38, height: 38)
                Text(habit.title)
                    .font(.headline)
                    .foregroundStyle(.labelVibrantPrimary)
            }
            Spacer()
            CardStreakButton(habit: habit)
        }
    }
}

#if DEBUG

import SwiftData

#Preview {
    CardHeader(habit: SampleData.shared.sampleHabit)
        .modelContainer(SampleData.shared.container)
        .padding(.horizontal)
}
#endif
