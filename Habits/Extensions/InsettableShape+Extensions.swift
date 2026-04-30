//
//  InsettableShape+Extensions.swift
//  Habits
//
//  Created by Andrey on 29/04/2026.
//

import SwiftUI

// TODO: Consolidate

extension InsettableShape {
    func applyDefaultStyling() -> some View {
        self
            .fill(.shape)
            .overlay {
                StrokeShapeView(
                    shape: self,
                    style: .shapeStroke,
                    strokeStyle: .init(lineWidth: 1),
                    isAntialiased: true,
                    background: Color.clear
                )
            }
            .shadow(color: .shapeShadow, radius: 14, y: 4)
    }
}

extension View {
    func defaultStyleShape<S: InsettableShape>(_ shape: S) -> some View {
        shape.applyDefaultStyling()
    }
}

#Preview {
    RoundedRectangle(cornerRadius: 36)
        .applyDefaultStyling()
        .frame(width: 128, height: 128)
}
