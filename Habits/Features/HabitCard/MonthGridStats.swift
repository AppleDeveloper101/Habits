//
//  MonthGridStats.swift
//  Habits
//
//  Created by Andrey on 22/07/2026.
//

import SwiftUI

struct MonthGridStats: View {
    
    private let monthGridSpacing: CGFloat = 8
    
    var body: some View {
        HStack(spacing: monthGridSpacing) {
            ForEach(0..<3) { month in
                monthGrid()
            }
        }
    }
    
    @ViewBuilder private func monthGrid() -> some View {
        Grid(alignment: .center, horizontalSpacing: 2, verticalSpacing: 2) {
            ForEach(0..<7) { _ in
                GridRow(alignment: .center) {
                    ForEach(0..<4) { _ in
                        Rectangle()
                            .aspectRatio(1, contentMode: .fit)
                    }
                }
            }
        }
    }
    
}

#Preview {
    MonthGridStats()
        .padding(12)
        .background {
            DefaultStyleShape(RoundedRectangle(cornerRadius: 24))
        }
        .padding()
}
}
