//
//  EmojiPicker.swift
//  Habits
//
//  Created by Andrey on 29/04/2026.
//

import SwiftUI

struct EmojiPicker: View {
    
    @Binding var emoji: String
    
    @FocusState private var isFocused
    
    var body: some View {
        Circle()
            .applyDefaultStyling()
            .frame(width: 44, height: 44)
            .overlay(content: overlayContent)
            .onChange(of: emoji, updateEmoji)
            .onTapGesture(perform: managePickerState)
    }
    
    @ViewBuilder private func overlayContent() -> some View {
        Image(systemName: "plus")
            .font(.title2)
            .foregroundStyle(.habitInfoSheetLabel)
            .opacity(emoji.isEmpty && !isFocused ? 1 : 0)
        Text(emoji)
            .font(.title2)
            .foregroundStyle(.accent)
        emojiTextField()
    }
    
    private func emojiTextField() -> some View {
        TextField("", text: $emoji)
            .tint(.accent)
            .focused($isFocused)
            .allowsHitTesting(false)
            .autocorrectionDisabled()
            .multilineTextAlignment(.center)
            .keyboardType(.init(rawValue: 124)!)
            .opacity(emoji.isEmpty && isFocused ? 1 : 0)
    }
    
    private func updateEmoji(oldValue: String, newValue: String) {
        if newValue.count < oldValue.count {
            emoji.removeAll()
        }
        
        emoji = String(newValue.suffix(1))
    }
    
    private func managePickerState() {
        isFocused = (isFocused && !emoji.isEmpty) ? false : true
        
        if !isFocused && emoji.isEmpty {
            emoji = "🎯"
        }
    }
}

#Preview {
    @Previewable @State var emoji = ""
    
    EmojiPicker(emoji: $emoji)
}
