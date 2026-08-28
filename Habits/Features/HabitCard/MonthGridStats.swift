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
    
    private let monthNameToGridSpacing: CGFloat = 4.0
    private let weekdaysToGridsSpacing: CGFloat = 4.0
    private let weekdaysSymbolWidth: CGFloat = 16.0
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
        HStack(alignment: .bottom, spacing: weekdaysToGridsSpacing) {
            weekdaysColumn(cellSize: cellSize)
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
    }
    
    @ViewBuilder private func grid(model: MonthGridViewModel, cellSize: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: monthNameToGridSpacing) {
            Text(model.date.formatted(.dateTime.month(.wide)))
                .foregroundStyle(.accent)
                .font(.footnote)
                .bold()
                .lineLimit(1)
                .frame(height: 18.0)
            
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
    
    @ViewBuilder private func weekdaysColumn(cellSize: CGFloat) -> some View {
        HStack(spacing: 2.0) {
            VStack(spacing: cellSpacing) {
                ForEach(["m", "t", "w", "t", "f", "s", "s"].map { $0.uppercased() }, id: \.self) { symbol in
                    Text(symbol)
                        .foregroundStyle(.accent)
                        .font(.system(size: 9.0))
                        .fontWeight(.semibold)
                        .frame(width: weekdaysSymbolWidth, height: cellSize)
                        .border(.pink.opacity(1/2))
                }
            }
            Capsule()
                .foregroundStyle(.monthGridStatsWeekdaysColumnSeparator)
                .frame(width: 1.0, height: cellSize * 7 + cellSpacing * 6)
        }
        .border(.green.opacity(1/2))
    }
    
}

private struct MonthGridViewModel: Identifiable {
    
    let id: UUID
    let date: Date
    let columnsCount: Int
    
    init() {
        self.id = UUID()
        self.date = .now
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
