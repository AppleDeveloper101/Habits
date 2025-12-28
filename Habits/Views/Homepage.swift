//
//  Homepage.swift
//  Habits
//
//  Created by Andrey on 27/12/2025.
//

import SwiftUI
import SwiftData

struct Homepage: View {
    @Query(sort: \Habit.created)
    private var habits: [Habit]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(habits) { habit in
                    HabitCard(habit: habit)
                }
            }
        }
        .navigationTitle("Habits")
        .scrollClipDisabled()
        .scrollIndicators(.hidden)
        .toolbarTitleDisplayMode(.inlineLarge)
        .padding([.top, .leading, .trailing])
    }
}

#Preview {
    NavigationStack {
        Homepage()
    }
    .modelContainer(SampleData.shared.container)
}
