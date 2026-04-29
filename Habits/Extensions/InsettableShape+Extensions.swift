//
//  InsettableShape+Extensions.swift
//  Habits
//
//  Created by Andrey on 29/04/2026.
//

import SwiftUI

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

#Preview {
    RoundedRectangle(cornerRadius: 36)
        .applyDefaultStyling()
        .frame(width: 128, height: 128)
}
