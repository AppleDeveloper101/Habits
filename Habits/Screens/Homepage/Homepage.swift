//
//  Homepage.swift
//  Habits
//
//  Created by Andrey on 27/04/2026.
//

import SwiftUI

struct Homepage: View {
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    Color.clear
                }
                .padding([.leading, .trailing, .top], 16)
            }
            .navigationTitle("Habits")
            .scrollIndicators(.hidden)
            .background(Color.background)
            .toolbar(content: newHabitButton)
            .toolbarTitleDisplayMode(.inlineLarge)
            .sheet(item: SheetManager.bindable.currentSheet) { $0.view }
        }
    }
    
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

#Preview {
    Homepage()
}
