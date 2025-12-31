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
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.labelVibrantPrimary]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.labelVibrantPrimary]
    }
}
