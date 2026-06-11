//
//  HabitCard.swift
//  Habits
//
//  Created by Andrey on 04/05/2026.
//

import SwiftUI

struct HabitCard: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    private let habit: Habit
    
    @State private var title: String
    @State private var emoji: String
    
    @State private var emojiScale = 1.0
    @State private var isAnimationInProgress = false
    
    init(_ habit: Habit) {
        self.habit = habit
        self.title = habit.title
        self.emoji = habit.emoji
    }
    
    var body: some View {
        VStack(spacing: .zero) {
            header()
            WeekRowStats(habit: habit)
        }
        .padding(12)
        .background(defaultStyleShape(RoundedRectangle(cornerRadius: 24), isElevated: true))
    }
    
    private func header() -> some View {
        HStack {
            HStack(spacing: 4) {
                Text(emoji.isEmpty ? "🎯" : emoji)
                    .font(.system(size: 34, weight: .regular))
                    .frame(width: 38, height: 38)
                    .scaleEffect(emojiScale)
                    .saturation(habit.emoji.isEmpty ? 0 : 1)
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
                    guard let newTitle = new[title] else { return }
                    
                    isAnimationInProgress = true
                    
                    if title != newTitle {
                        try? await Task.sleep(for: .seconds(0.45))
                        withAnimation { title = newTitle }
                    }
                    
                    if emoji != newEmoji {
                        try? await Task.sleep(for: .seconds(0.55))
                        
                        withAnimation(.spring(.bouncy(duration: 0.3))) { emojiScale = 0.2 }
                        try? await Task.sleep(for: .seconds(0.15))
                        withAnimation(.spring(.bouncy(duration: 0.3))) { emojiScale = 1.0 }
                        
                        emoji = newEmoji
                    }
                    
                    isAnimationInProgress = false
                }
            }
            
            Spacer()
            
            StreakButton(habit: habit)
        }
    }
}
