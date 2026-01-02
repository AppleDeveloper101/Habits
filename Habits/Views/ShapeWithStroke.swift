//
//  ShapeWithStroke.swift
//  Habits
//
//  Created by Andrey on 02/01/2026.
//

import SwiftUI

struct ShapeWithStroke<S: InsettableShape>: View {
    private let shape: S
    
    init(_ shape: S) {
        self.shape = shape
    }
    
    var body: some View {
        shape
            .fill(.background)
            .shadow(color: .black.opacity(0.10), radius: 14, y: 4)
            .overlay {
                shape
                    .strokeBorder(lineWidth: 1)
                    .foregroundStyle(Color(hue: 0, saturation: 0, brightness: 0.84))
            }
    }
}

#Preview {
    let shape = RoundedRectangle(cornerRadius: 12)
    
    ShapeWithStroke(shape)
        .frame(width: 128, height: 128)
}
