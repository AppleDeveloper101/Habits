//
//  InsettableShape+Extensions.swift
//  Habits
//
//  Created by Andrey on 29/04/2026.
//

import SwiftUI

extension InsettableShape {
    func applyDefaultStyling(isElevated: Bool = false) -> some View {
        self
            .fill(isElevated ? .shapeElevated : .shape)
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
    func defaultStyleShape<S: InsettableShape>(_ shape: S, isElevated: Bool = false) -> some View {
        shape.applyDefaultStyling(isElevated: isElevated)
    }
}

#Preview {
    RoundedRectangle(cornerRadius: 36)
        .applyDefaultStyling()
        .frame(width: 128, height: 128)
}
