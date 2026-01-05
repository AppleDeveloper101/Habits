//
//  NewHabitSheet.swift
//  Habits
//
//  Created by Andrey on 31/12/2025.
//

import SwiftUI
import SwiftData

struct NewHabitSheet: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var emoji: String = ""
    @State private var title: String = ""
    
    private var formattedTitle: String {
        title.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private let emojiToTextFieldSpacing: CGFloat = 8
    
    var body: some View {
        VStack {
            HStack(spacing: emojiToTextFieldSpacing) {
                EmojiPicker($emoji)
                TitleTextField($title)
            }
            .padding()
        }
        .navigationTitle("New Habit")
        .toolbarTitleDisplayMode(.inline)
        .presentationDetents([.fraction(0.19)])
        .frame(maxHeight: .infinity, alignment: .top)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel", systemImage: "xmark", role: .cancel) {
                    dismiss()
                }
                .tint(.labelVibrantPrimary)
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Done", systemImage: "checkmark") {
                    let newHabit = Habit(title: formattedTitle, emoji: emoji)
                    context.insert(newHabit)
                    dismiss()
                }
                .tint(.labelVibrantPrimary)
                .disabled(formattedTitle.isEmpty)
            }
        }
    }
}

// TODO: Update #Preview

#Preview {
    @Previewable @State var isPresented = true
    
    Toggle("Sheet", isOn: $isPresented)
        .padding(.horizontal, 32)
        .sheet(isPresented: $isPresented) {
            NavigationStack {
                NewHabitSheet()
            }
        }
}
