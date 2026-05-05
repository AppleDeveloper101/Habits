//
//  InsettableShape+Extensions.swift
//  Habits
//
//  Created by Andrey on 29/04/2026.
//

import SwiftUI

extension InsettableShape {
    func applyDefaultStyling(isElevated: Bool = false, isShadowEnabled: Bool = true) -> some View {
        self
            .fill(isElevated ? .shapeElevated : .shape)
            .overlay {
                StrokeBorderShapeView(
                    shape: self,
                    style: .shapeStroke,
                    strokeStyle: .init(lineWidth: 1),
                    isAntialiased: true,
                    background: Color.clear
                )
            }
            .shadow(color: isShadowEnabled ? .shapeShadow : .clear, radius: 14, y: 4)
    }
}

extension View {
    func defaultStyleShape<S: InsettableShape>(_ shape: S, isElevated: Bool = false, isShadowEnabled: Bool = true) -> some View {
        shape.applyDefaultStyling(isElevated: isElevated, isShadowEnabled: isShadowEnabled)
    }
}

#Preview {
    RoundedRectangle(cornerRadius: 36)
        .applyDefaultStyling()
        .frame(width: 128, height: 128)
}
