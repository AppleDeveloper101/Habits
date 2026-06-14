//
//  HabitCard.swift
//  Habits
//
//  Created by Andrey on 04/05/2026.
//

import SwiftUI

struct HabitCard: View {
    
    private let habit: Habit
    
    init(_ habit: Habit) {
        self.habit = habit
    }
    
    var body: some View {
        VStack(spacing: .zero) {
            HabitCardHeader(habit)
            WeekRowStats(habit: habit)
        }
        .padding(12)
        .background(defaultStyleShape(RoundedRectangle(cornerRadius: 24), isElevated: true))
    }
}

struct HabitCardHeader: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    private let habit: Habit
    
    @State private var title: String
    @State private var emoji: String
    
    @State private var saturation: CGFloat = 0.0
    @State private var emojiScale = 1.0
    @State private var isAnimationInProgress = false
    
    private var displayedEmoji: String { emoji.isEmpty ? "🎯" : emoji }
    
    init(_ habit: Habit) {
        self.habit = habit
        self.title = habit.title
        self.emoji = habit.emoji
        self._saturation = State(initialValue: emoji.isEmpty ? 0.0 : 1.0)
    }
    
    var body: some View {
        HStack {
            HStack(spacing: 4) {
                Text(displayedEmoji)
                    .font(.system(size: 34, weight: .regular))
                    .frame(width: 38, height: 38)
                    .scaleEffect(emojiScale)
                    .saturation(saturation)
                    .contrast(habit.emoji.isEmpty ? 1.17 : 1)
                    .brightness(
                        colorScheme == .light ? 0
                        : habit.emoji.isEmpty ? 0 : -0.14
                    )
                Text(title)
                    .font(.headline)
                    .contentTransition(.numericText())
            }
            .foregroundStyle(.accent)
            .onTapGesture { ModalManager.shared.present(.habitInfoSheet(habit)) }
            .onChange(of: [emoji: habit.emoji, title: habit.title]) { old, new in
                Task {
                    guard !isAnimationInProgress else { return }
                    guard let newEmoji = new[emoji] else { return }
                    guard let oldEmoji = old[emoji] else { return }
                    guard let newTitle = new[title] else { return }
                    
                    isAnimationInProgress = true
                    
                    if title != newTitle {
                        try? await Task.sleep(for: .seconds(0.5))
                        withAnimation { title = newTitle }
                    }
                    
                    if newEmoji.isDefaultEmoji && oldEmoji.isEmpty || newEmoji.isEmpty && oldEmoji.isDefaultEmoji {
                        try? await Task.sleep(for: .seconds(0.5))
                        withAnimation(.smooth(duration: 0.8)) {
                            saturation = newEmoji.isEmpty ? 0.0 : 1.0
                        }
                    } else {
                        if emoji != newEmoji {
                            try? await Task.sleep(for: .seconds(0.55))
                            
                            withAnimation(.spring(.bouncy(duration: 0.3))) { emojiScale = 0.2 }
                            try? await Task.sleep(for: .seconds(0.15))
                            withAnimation(.spring(.bouncy(duration: 0.3))) { emojiScale = 1.0 }
                            
                            saturation = newEmoji.isEmpty ? 0.0 : 1.0
                            emoji = newEmoji
                        }
                    }
                    
                    isAnimationInProgress = false
                }
            }
            
            Spacer()
            
            StreakButton(habit: habit)
        }
    }
}
