//
//  HabitInfoSheet.swift
//  Habits
//
//  Created by Andrey on 30/04/2026.
//

import SwiftUI

struct HabitInfoSheet: View {
    
    @Environment(\.dismiss) private var dismiss
    
    private let habit: Habit?
    
    @State private var emoji: String
    @State private var title: String
    
    @State private var contentHeight: CGFloat = 0
    @State private var isKeyboardPresented = false
    
    private var bottomEdgeSafeAreaInset: CGFloat {
        let windowScene = UIApplication.shared.connectedScenes.first { scene in
            scene.activationState == .foregroundActive
        } as? UIWindowScene
        
        return windowScene?.keyWindow?.safeAreaInsets.bottom ?? 0
    }
    
    private var calculatedBottomEdgePadding: CGFloat {
        isKeyboardPresented ? 0 : (16 - bottomEdgeSafeAreaInset)
    }
    
    init(_ habit: Habit? = nil) {
        self.habit = habit
        self.emoji = habit?.emoji ?? ""
        self.title = habit?.title ?? ""
    }
    
    var body: some View {
        Color.clear.overlay(alignment: .top) {
            sheetContent()
                .receiveKeyboardPresentationState($isKeyboardPresented)
                .presentationDetents([.height(contentHeight)])
                .readHeight(into: $contentHeight)
                .modify { view in
                    if #available(iOS 26.0, *) {
                        view
                    } else {
                        view.presentationCornerRadius(38)
                    }
                }
        }
    }
    
    private func sheetContent() -> some View {
        VStack(spacing: 24) {
            sheetHeader()
                .padding([.leading, .trailing, .top], 16)
            inputControls()
                .padding(.horizontal, 16)
                .modify { view in
                    if #available(iOS 26.0, *) {
                        view.padding(.bottom, calculatedBottomEdgePadding)
                    } else {
                        view
                    }
                }
        }
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
            dismiss()
        } label: {
            Circle()
                .frame(height: 44)
                .overlay {
                    Image(systemName: "xmark")
                        .tint(.accent)
                        .font(.system(size: 22, weight: .regular))
                }
                .modify { view in
                    if #available(iOS 26.0, *) {
                        view
                            .tint(.habitInfoSheetCancelButton)
                            .glassEffect(.regular.interactive())
                    } else {
                        view
                            .tint(.black.opacity(0.1))
                    }
                }
        }
    }
    
    private func confirmButton() -> some View {
        Button {
            if let habit {
                habit.emoji = emoji
                habit.title = title
            } else {
                DataManager.shared.insert(Habit(emoji: emoji, title: title))
            }
            dismiss()
        } label: {
            Circle()
                .frame(height: 44)
                .overlay {
                    Image(systemName: "checkmark")
                        .tint(.complementary)
                        .font(.system(size: 22, weight: .medium))
                }
                .modify { view in
                    if #available(iOS 26.0, *) {
                        view
                            .tint(.accent)
                            .glassEffect(.regular.interactive())
                    } else {
                        view
                            .tint(.accent)
                    }
                }
        }
    }
    
    private func inputControls() -> some View {
        HStack(spacing: 8) {
            EmojiPicker(emoji: $emoji)
            TitleTextField(title: $title)
        }
    }
}

#Preview {
    @Previewable @State var isPresented = true
    
    Color.background.ignoresSafeArea()
        .sheet(isPresented: $isPresented) {
            HabitInfoSheet()
        }
        .onTapGesture {
            isPresented = true
        }
}
