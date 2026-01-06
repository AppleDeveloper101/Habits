//
//  EmojiPicker.swift
//  Habits
//
//  Created by Andrey on 05/01/2026.
//

import SwiftUI

struct EmojiPicker: View {
    @Binding private var emoji: String
    
    @FocusState private var isFocused
    
    init(_ emoji: Binding<String>) {
        self._emoji = emoji
    }
    
    var body: some View {
        ShapeWithStroke(Circle())
            .overlay(alignment: .center) {
                TextField("", text: $emoji)
                    .focused($isFocused)
                    .keyboardType(UIKeyboardType(rawValue: 124)!)
                    .tint(.labelVibrantPrimary)
                    .multilineTextAlignment(.center)
                    .containerRelativeFrame(.horizontal)
                    .onChange(of: emoji) { oldValue, newValue in
                        emoji = (newValue.first?.description ?? "⚠️")
                        // FIXME: Prone to passing through more than one symbol
                    }
            }
            .overlay {
                if emoji.isEmpty && !isFocused {
                    Image(systemName: "plus")
                        .foregroundStyle(.fillVibrantSecondary)
                }
            }
            .font(.title2)
            .frame(width: 44, height: 44)
            .onTapGesture { isFocused = true }
    }
}

#Preview {
    @Previewable @State var emoji = ""
    
    EmojiPicker($emoji)
}
