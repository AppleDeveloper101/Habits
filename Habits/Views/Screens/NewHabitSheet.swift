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
    
    @FocusState private var currentFocus: String?
    
    @State private var title: String = ""
    @State private var emoji: String = ""
    
    private var formattedTitle: String {
        title.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private let emojiPromptText = Text("")
    private let titlePromptText = {
        Text("Title...")
            .font(.headline)
            .foregroundStyle(.fillVibrantSecondary)
    }()
    
    private let emojiToTextFieldSpacing: CGFloat = 8
    private let controlHeight: CGFloat = 44
    
    var body: some View {
        VStack {
            HStack(spacing: emojiToTextFieldSpacing) {
                TextField("Emoji", text: $emoji, prompt: emojiPromptText)
                    .focused($currentFocus, equals: "emoji")
                    .keyboardType(UIKeyboardType(rawValue: 124)!)
                    .font(.title2)
                    .fixedSize()
                    .frame(width: controlHeight / 2, height: controlHeight / 2)
                    .frame(width: controlHeight, height: controlHeight)
                    .backgroundWithStrokeOverlay(shape: Circle())
                    .onTapGesture { currentFocus = "emoji" }
                    .overlay {
                        if emoji.isEmpty && currentFocus != "emoji" {
                            Image(systemName: "plus")
                                .font(.title2)
                                .foregroundStyle(.fillVibrantSecondary)
                        }
                    }
                TextField("Title", text: $title, prompt: titlePromptText)
                    .focused($currentFocus, equals: "title")
                    .font(.headline)
                    .foregroundStyle(.labelVibrantPrimary)
                    .padding(.horizontal, 12)
                    .frame(height: controlHeight)
                    .backgroundWithStrokeOverlay(shape: Capsule())
            }
            .padding()
        }
        .navigationTitle("New Habit")
        .toolbarTitleDisplayMode(.inline)
        .frame(maxHeight: .infinity, alignment: .top)
        .presentationDetents([.height(146)])
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
