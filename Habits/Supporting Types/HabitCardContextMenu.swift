//
//  HabitCardContextMenu.swift
//  Habits
//
//  Created by Andrey on 28/12/2025.
//

import SwiftUI
import SwiftData

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
