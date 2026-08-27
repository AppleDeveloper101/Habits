//
//  MonthGridStats.swift
//  Habits
//
//  Created by Andrey on 05/08/2026.
//

import SwiftUI

struct MonthGridStats: View {
    
    private let gridModels: [MonthGridViewModel]
    
    private let gridsCount: Int = 3
    private let columnsCount: Int
    private let gridGapsCount: Int
    private let cellGapsCount: Int
    
    private let cellSpacing: CGFloat = 2.0
    private let gridSpacing: CGFloat = 8.0
    private let spacingTotal: CGFloat
    
    @State private var gridsContainerWidth: CGFloat = 0.0
    
    var leanWidth: CGFloat { gridsContainerWidth - spacingTotal }
    var cellSize: CGFloat { leanWidth / Double(columnsCount) }
    
    init() {
        self.gridModels = (0..<gridsCount).map { _ in
            MonthGridViewModel()
        }
        
        self.columnsCount = gridModels.reduce(0) { $0 + $1.columnsCount }
        self.gridGapsCount = gridsCount - 1
        self.cellGapsCount = columnsCount - gridsCount
        
        self.spacingTotal = cellSpacing * Double(cellGapsCount) + gridSpacing * Double(gridGapsCount)
    }
    
    var body: some View {
        HStack(spacing: gridSpacing) {
            ForEach(gridModels) { model in
                grid(model: model, cellSize: cellSize)
                    .border(.blue.opacity(1/2))
            }
        }
        .frame(maxWidth: .infinity)
        .readSize(.horizontal, into: $gridsContainerWidth)
        .border(.green.opacity(1/2))
    }
    
    @ViewBuilder private func grid(model: MonthGridViewModel, cellSize: CGFloat) -> some View {
        Grid(horizontalSpacing: cellSpacing, verticalSpacing: cellSpacing) {
            ForEach(0..<7) { row in
                GridRow {
                    ForEach(0..<model.columnsCount, id: \.self) { column in
                        Mark()
                            .frame(width: cellSize)
                            .border(.black.opacity(1/2))
                    }
                }
            }
        }
    }
    
}

private struct MonthGridViewModel: Identifiable {
    
    let id: UUID
    let columnsCount: Int
    
    init() {
        self.id = UUID()
        self.columnsCount = .random(in: 1...6)
    }
    
}

#Preview {
    ScrollView {
        VStack {
            MonthGridStats()
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).applyDefaultStyling())
        }
        .border(.purple, width: 1)
        .padding(.horizontal)
    }
    .scrollClipDisabled()
}
