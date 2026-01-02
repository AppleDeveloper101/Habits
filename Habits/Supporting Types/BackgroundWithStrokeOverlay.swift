//
//  BackgroundWithStrokeOverlay.swift
//  Habits
//
//  Created by Andrey on 29/12/2025.
//

import SwiftUI

struct BackgroundWithStrokeOverlay<S: InsettableShape>: ViewModifier {
    private let shape: S
    
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

extension View {
    func backgroundWithStrokeOverlay<S: InsettableShape>(shape: S) -> some View {
        modifier(BackgroundWithStrokeOverlay(shape: shape))
    }
}
