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
    
    init(_ habit: Habit) {
        self.habit = habit
        self.title = habit.title
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
                Text(habit.emoji.isEmpty ? "🎯" : habit.emoji)
                    .font(.system(size: 34, weight: .regular))
                    .frame(width: 38, height: 38)
                    .saturation(habit.emoji.isEmpty ? 0 : 1)
                    .contrast(habit.emoji.isEmpty ? 1.17 : 1)
                    .brightness(
                        colorScheme == .light ? 0
                        : habit.emoji.isEmpty ? 0 : -0.14
                    )
                Text(title)
                    .font(.headline)
                    .contentTransition(.numericText())
                    .onChange(of: habit.title) { _, newValue in
                        Task {
                            try? await Task.sleep(for: .seconds(0.5))
                            withAnimation { title = newValue }
                        }
                    }
            }
            .foregroundStyle(.accent)
            .onTapGesture { ModalManager.shared.present(.habitInfoSheet(habit)) }
            
            Spacer()
            
            StreakButton(habit: habit)
        }
    }
}
