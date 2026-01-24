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
    @State private var detentHeight: CGFloat = .zero
    
    private var formattedTitle: String {
        title.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private let emojiToTextFieldSpacing: CGFloat = 8
    
    var body: some View {
        VStack(spacing: .zero) {
            header()
            HStack(spacing: emojiToTextFieldSpacing) {
                EmojiPicker($emoji)
                TitleTextField($title)
            }
            .padding(16)
        }
        .setHeight(for: $detentHeight)
        .frame(maxHeight: .infinity, alignment: .top)
        .presentationDetents([.height(detentHeight)])
    }
    
    private func header() -> some View {
        HStack(spacing: .zero) {
            cancelButton()
            Spacer()
            headerTitle()
            Spacer()
            confirmButton()
        }
        .padding(.horizontal)
        .padding(.top, 16)
        .padding(.bottom, 10)
    }
    
    private func cancelButton() -> some View {
        Button {
            dismiss()
        } label: {
            Circle()
                .fill(.quaternary)
                .frame(width: 44, height: 44)
                .overlay {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundStyle(.labelVibrantPrimary)
                }
        }
        .buttonStyle(.plain)
    }
    
    private func headerTitle() -> some View {
        Text("New Habit")
            .font(.headline)
            .foregroundStyle(.labelVibrantPrimary)
    }
    
    private func confirmButton() -> some View {
        Button {
            let newHabit = Habit(title: formattedTitle, emoji: emoji)
            context.insert(newHabit)
            dismiss()
        } label: {
            Circle()
                .fill(.labelVibrantPrimary)
                .frame(width: 44, height: 44)
                .overlay {
                    Image(systemName: "checkmark")
                        .font(.title2)
                        .foregroundStyle(.white)
                }
        }
        .buttonStyle(.plain)
    }
}

// Source – CalendarSheet.swift
private extension View {
    func setHeight(for property: Binding<CGFloat>) -> some View {
        self
            .overlay {
                GeometryReader { proxy in
                    Color.clear
                        .onGeometryChange(for: CGFloat.self) { proxy in
                            proxy.size.height
                        } action: { newHeight in
                            property.wrappedValue = newHeight
                        }
                }
            }
    }
}

#Preview {
    @Previewable @State var isPresented = true
    
    Color(.systemBackground)
        .onTapGesture {
            isPresented = true
        }
        .sheet(isPresented: $isPresented) {
            NewHabitSheet()
        }
}
