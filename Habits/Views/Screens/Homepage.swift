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
    
    @State private var isNewHabitSheetPresented = false
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(habits) { habit in
                    HabitCard(habit: habit)
                        .habitCardContextMenu(habit: habit)
                }
            }
        }
        .navigationTitle("Habits")
        .scrollClipDisabled()
        .scrollIndicators(.hidden)
        .toolbarTitleDisplayMode(.inlineLarge)
        .padding([.top, .leading, .trailing])
        .toolbar {
            Button("Add Habit", systemImage: "plus") {
                isNewHabitSheetPresented = true
            }
            .tint(Color.labelVibrantPrimary)
        }
        .sheet(isPresented: $isNewHabitSheetPresented) {
            NavigationStack {
                NewHabitSheet()
            }
        }
    }
}

#Preview {
    NavigationStack {
        Homepage()
    }
    .modelContainer(sampleContainer)
}
