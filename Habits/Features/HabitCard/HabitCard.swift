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
        VStack(spacing: 8) {
            header()
        }
        .padding(12)
        .background(defaultStyleShape(RoundedRectangle(cornerRadius: 24), isElevated: true))
        .contentShape(RoundedRectangle(cornerRadius: 24).inset(by: 12))
        .contentShape(.contextMenuPreview, RoundedRectangle(cornerRadius: 24))
        .onTapGesture {
            SheetManager.shared.present(.habitInfoSheet(habit))
        }
        .contextMenu {
            Button("Delete", systemImage: "trash", role: .destructive) {
                DataManager.shared.delete(habit)
            }
        }
    }
    
    private func header() -> some View {
        HStack {
            HStack(spacing: 4) {
                Text(habit.emoji)
                    .frame(width: 38, height: 38)
                    .font(.system(size: 34, weight: .regular))
                Text(habit.title)
                    .font(.headline)
            }
            .foregroundStyle(.accent)
            
            Spacer()
            
            StreakButton(habit: habit)
        }
    }
}
