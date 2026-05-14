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
            .sheet(item: SheetManager.bindable.currentSheet) { $0.view }
            .overlay {
                if SheetManager.shared.currentSheet != nil {
                    Color.clear.contentShape(.rect)
                        .onTapGesture { SheetManager.shared.dismiss() }
                }
            }
        }
        .animation(.smooth) { view in
            view.blur(radius: SheetManager.shared.currentSheet == nil ? 0 : 6)
        }
    }
    
    // TODO: Disable when sheet is presented
    
    func newHabitButton() -> some View {
        Button {
            SheetManager.shared.present(.habitInfoSheet())
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
