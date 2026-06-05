//
//  HabitInfoSheet.swift
//  Habits
//
//  Created by Andrey on 30/04/2026.
//

import SwiftUI

struct HabitInfoSheet: View {
    
    private let habit: Habit?
    
    @State private var emoji: String
    @State private var title: String
    
    private var formattedTitle: String {
        title.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    init(_ habit: Habit? = nil) {
        self.habit = habit
        self.emoji = habit?.emoji ?? ""
        self.title = habit?.title ?? ""
    }
    
    var body: some View {
        VStack(spacing: 24) {
            sheetHeader()
            VStack(spacing: 12) {
                inputControls()
                
                if let habit {
                    ConfirmationButton {
                        DataManager.shared.delete(habit)
                        ModalManager.shared.dismiss()
                    }
                }
            }
        }
        .padding(16)
    }
    
    private func sheetHeader() -> some View {
        HStack {
            cancelButton()
            Spacer()
            Text(habit == nil ? "New Habit" : "Edit Habit")
                .font(.headline)
                .foregroundStyle(.accent)
            Spacer()
            confirmButton()
        }
    }
    
    private func cancelButton() -> some View {
        Button {
            ModalManager.shared.dismiss()
        } label: {
            Circle()
                .frame(height: 44)
                .tint(.habitInfoSheetCancelButton)
                .overlay {
                    Image(systemName: "xmark")
                        .tint(.accent)
                        .font(.system(size: 22, weight: .regular))
                }
                .modify { view in
                    if #available(iOS 26.0, *) {
                        view
                            .glassEffect(.regular.interactive())
                    } else {
                        view
                    }
                }
        }
    }
    
    @ViewBuilder private func confirmButton() -> some View {
        var isEnabled: Bool { !formattedTitle.isEmpty }
        
        Button {
            guard isEnabled else { return }
            if let habit {
                habit.emoji = emoji
                habit.title = formattedTitle
            } else {
                DataManager.shared.insert(Habit(emoji: emoji, title: formattedTitle))
            }
            ModalManager.shared.dismiss()
        } label: {
            Circle()
                .frame(height: 44)
                .tint(isEnabled ? .accent : .confirmationButtonDisabled)
                .overlay {
                    Image(systemName: "checkmark")
                        .tint(.sheetBackground)
                        .font(.system(size: 22, weight: .medium))
                }
                .modify { view in
                    if #available(iOS 26.0, *) {
                        view
                            .glassEffect(.regular.interactive(isEnabled))
                    } else {
                        view
                    }
                }
        }
        .allowsHitTesting(isEnabled)
        .animation(.smooth(duration: 0.3), value: isEnabled)
    }
    
    private func inputControls() -> some View {
        HStack(spacing: 8) {
            EmojiPicker(emoji: $emoji)
            TitleTextField(title: $title)
        }
    }
}

#Preview {
    let habit = Habit(emoji: "🥖", title: "Baguette")
    
    Color.background.ignoresSafeArea()
        .modalPresenter()
        .task {
            ModalManager.shared.present(.habitInfoSheet(habit))
        }
        .onTapGesture {
            ModalManager.shared.present(.habitInfoSheet(habit))
        }
}
