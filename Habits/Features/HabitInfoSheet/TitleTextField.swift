//
//  TitleTextField.swift
//  Habits
//
//  Created by Andrey on 30/04/2026.
//

import SwiftUI

struct TitleTextField: View {
    
    @Binding var title: String
    
    @State private var promptText: String

    init(title: Binding<String>) {
        self._title = title
        self.promptText = title.wrappedValue.isEmpty ? "New Habit..." : title.wrappedValue
    }
    
    var body: some View {
        TextField("Habit Title", text: $title, prompt: prompt)
            .tint(.accent)
            .font(.headline)
            .foregroundStyle(.accent)
            .frame(height: 44)
            .padding(.horizontal, 12)
            .background(defaultStyleShape(.capsule))
    }
    
    private var prompt: Text {
        Text(promptText)
            .font(.headline)
            .foregroundStyle(.habitInfoSheetLabel)
    }
}

#Preview {
    @Previewable @State var title = ""
    
    TitleTextField(title: $title)
        .padding(.horizontal, 32)
}
