//
//  View+Extensions.swift
//  Habits
//
//  Created by Andrey on 21/12/2025.
//

import SwiftUI

extension View {
    func dimensionsOverlay(fontColor: Color = .pink, fontSize: CGFloat = 16, displayedInside: Bool = false) -> some View {
        self.overlay {
            GeometryReader { proxy in
                Text("\(proxy.size.width.description) \(proxy.size.height.description)")
                    .offset(y: displayedInside ? 0 : proxy.size.height + 4)
                    .font(.system(size: fontSize, weight: .thin))
                    .foregroundStyle(fontColor)
                    .monospaced()
                    .fixedSize()
            }
        }
    }
}
