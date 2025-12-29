//
//  HabitsApp.swift
//  Habits
//
//  Created by Andrey on 21/12/2025.
//

import SwiftUI
import SwiftData

@main
struct HabitsApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                Homepage()
            }
        }
        .modelContainer(for: [Habit.self, Record.self])
    }
}
