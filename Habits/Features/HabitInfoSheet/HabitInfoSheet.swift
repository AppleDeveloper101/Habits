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
                .presentationBackgroundInteraction(.enabled)
                .readHeight(into: $contentHeight)
                .modify { view in
                    if #available(iOS 26.0, *) {
                        view
                            .presentationBackground(.sheetBackgroundGlass)
                    } else {
                        view
                            .presentationCornerRadius(38)
                            .presentationBackground { Color.sheetBackground.padding(-999_999) }
                    }
                }
        }
    }
    
    private func sheetContent() -> some View {
        VStack(spacing: 24) {
            sheetHeader()
            VStack(spacing: 12) {
                inputControls()
                
                if let habit {
                    HabitDeleteButton(habit) {
                        DataManager.shared.delete(habit)
                        SheetManager.shared.dismiss()
                    }
                }
            }
        }
        .padding([.leading, .trailing, .top], 16)
        .modify { view in
            if #available(iOS 26.0, *) {
                view.padding(.bottom, calculatedBottomEdgePadding)
            } else {
                view
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
            SheetManager.shared.dismiss()
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
    
    // TODO: Disable when title is empty
    private func confirmButton() -> some View {
        Button {
            if let habit {
                habit.emoji = emoji
                habit.title = title
            } else {
                DataManager.shared.insert(Habit(emoji: emoji, title: title))
            }
            SheetManager.shared.dismiss()
        } label: {
            Circle()
                .frame(height: 44)
                .tint(.accent)
                .overlay {
                    Image(systemName: "checkmark")
                        .tint(.sheetBackground)
                        .font(.system(size: 22, weight: .medium))
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
            HabitInfoSheet(.init(emoji: "🥖", title: "Baguette"))
        }
        .onTapGesture {
            isPresented = true
        }
}
