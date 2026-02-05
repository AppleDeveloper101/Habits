//
//  BackgroundWithStroke.swift
//  Habits
//
//  Created by Andrey on 29/12/2025.
//

import SwiftUI

private struct BackgroundWithStroke<S: InsettableShape>: ViewModifier {
    
    // MARK: - Properties
    
    let shape: S
    
    let backgroundColor: Color = .init(uiColor: .systemBackground)
    let shadowColor: Color = .black.opacity(0.12)
    let strokeColor: Color = .stroke
    let shadowRadius: CGFloat = 14
    let shadowYOffset: CGFloat = 4
    let strokeLineWidth: CGFloat = 1
    
    var strokeStyle: StrokeStyle {
        .init(lineWidth: strokeLineWidth)
    }
    
    // MARK: - Initializers
    
    init(shape: S) {
        self.shape = shape
    }
    
    // MARK: - Body
    
    func body(content: Content) -> some View {
        content
            .mask {
                shape
            }
            .background {
                shape
                    .fill(backgroundColor)
                    .shadow(color: shadowColor, radius: shadowRadius, y: shadowYOffset)
            }
            .overlay {
                StrokeShapeView(
                    shape: shape,
                    style: strokeColor,
                    strokeStyle: strokeStyle,
                    isAntialiased: true,
                    background: Color.clear
                )
            }
    }
}

// MARK: - Extensions

extension View {
    func backgroundWithStroke<S: InsettableShape>(shape: S) -> some View {
        modifier(BackgroundWithStroke(shape: shape))
    }
}
