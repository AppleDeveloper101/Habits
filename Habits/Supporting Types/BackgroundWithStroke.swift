//
//  BackgroundWithStroke.swift
//  Habits
//
//  Created by Andrey on 29/12/2025.
//

import SwiftUI

struct BackgroundWithStroke<S: InsettableShape>: ViewModifier {
    private var shape: S
    
    init(shape: S) {
        self.shape = shape
    }
    
    func body(content: Content) -> some View {
        content
            .background {
                shape
                    .fill(.background)
                    .shadow(color: .black.opacity(0.10), radius: 14, y: 4)
            }
            .overlay {
                shape
                    .strokeBorder(lineWidth: 1)
                    .foregroundStyle(Color(hue: 0, saturation: 0, brightness: 0.84))
            }
    }
}
