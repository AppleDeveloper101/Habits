//
//  Mark.swift
//  Habits
//
//  Created by Andrey on 06/08/2026.
//

import SwiftUI

struct Mark: View {
    
    let hasRecord: Bool
    let isToday: Bool
    
    var scaleFactor: CGFloat { hasRecord ? 1.0 : isToday ? 0.5 : 0.25 }
    
    init(hasRecord: Bool = false, isToday: Bool = false) {
        self.hasRecord = hasRecord
        self.isToday = isToday
    }
    
    var body: some View {
        GeometryReader { proxy in
            let cornerRadius = min(proxy.size.width, proxy.size.height) * markCornerRadiusCoefficient
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(
                    LinearGradient(
                        colors: hasRecord || isToday ? [.weekRowCellStart, .weekRowCellEnd] : [.weekRowEmptyCell],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: proxy.size.width * scaleFactor, height: proxy.size.height * scaleFactor)
                .position(x: proxy.size.width / 2.0, y: proxy.size.height / 2.0)
        }
        .aspectRatio(1, contentMode: .fit)
    }
    
}

#Preview {
    VStackLayout(spacing: 2) {
        Mark(hasRecord: false)
        Mark(hasRecord: true)
        Mark(hasRecord: false, isToday: true)
    }
    .frame(height: 128)
}
