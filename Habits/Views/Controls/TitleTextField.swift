//
//  TitleTextField.swift
//  Habits
//
//  Created by Andrey on 05/01/2026.
//

import SwiftUI

struct TitleTextField: View {
    @Binding private var text: String
    
    @FocusState private var isFocused
    
    private let prompt = {
        Text("Title...")
            .font(.headline)
            .foregroundStyle(.fillVibrantSecondary)
    }()
    
    init(_ text: Binding<String>) {
        self._text = text
    }
    
    var body: some View {
        TextField("Title", text: $text, prompt: prompt)
            .focused($isFocused)
            .font(.headline)
            .tint(.labelVibrantPrimary)
            .foregroundStyle(.labelVibrantPrimary)
            .padding(.horizontal, 12)
            .frame(height: 44)
            .backgroundWithStroke(shape: Capsule())
    }
}

#Preview {
    @Previewable @State var text = ""
    
    TitleTextField($text)
        .padding()
}
