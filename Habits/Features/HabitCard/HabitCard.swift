//
//  HabitCard.swift
//  Habits
//
//  Created by Andrey on 04/05/2026.
//

import SwiftUI

struct HabitCard: View {
    
    private let habit: Habit
    
    @State private var title: String
    
    init(_ habit: Habit) {
        self.habit = habit
        self.title = habit.title
    }
    
    var body: some View {
        VStack(spacing: 8) {
            header()
        }
        .padding(12)
        .background(defaultStyleShape(RoundedRectangle(cornerRadius: 24), isElevated: true))
        .contentShape(RoundedRectangle(cornerRadius: 24).inset(by: 12))
        .onTapGesture {
            SheetManager.shared.present(.habitInfoSheet(habit))
        }
    }
    
    private func header() -> some View {
        HStack {
            HStack(spacing: 4) {
                Text(habit.emoji.isEmpty ? "🎯" : habit.emoji)
                    .saturation(habit.emoji.isEmpty ? 0 : 1)
                    .contrast(habit.emoji.isEmpty ? 1.17 : 1)
                    .frame(width: 38, height: 38)
                    .font(.system(size: 34, weight: .regular))
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
            
            Spacer()
            
            StreakButton(habit: habit)
        }
    }
}
