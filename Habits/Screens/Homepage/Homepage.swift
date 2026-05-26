//
//  Homepage.swift
//  Habits
//
//  Created by Andrey on 27/04/2026.
//

import SwiftUI
import SwiftData

struct Homepage: View {
    
    @Query(sort: \Habit.timestamp, order: .reverse) private var habits: [Habit]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if !habits.isEmpty {
                    VStack(spacing: 16) {
                        ForEach(habits) {
                            HabitCard($0)
                        }
                    }
                    .padding([.leading, .trailing, .top], 16)
                }
            }
            .navigationTitle("Habits")
            .scrollIndicators(.hidden)
            .background(Color.background)
            .toolbar(content: newHabitButton)
            .toolbarTitleDisplayMode(.inlineLarge)
        }
        .modalPresenter()
    }
    
    func newHabitButton() -> some View {
        Button {
            ModalManager.shared.present() // TODO: New habit form
        } label: {
            Image(systemName: "plus")
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(.isLiquidGlassAvailable ? .complementary : .accent)
        }
        .modify { view in
            if #available(iOS 26.0, *) {
                view
                    .tint(.accentGlass)
                    .buttonStyle(.glassProminent)
            } else {
                view
            }
        }
    }
}

#Preview {
    Homepage()
        .modelContainer(DataManager.shared.container)
}
