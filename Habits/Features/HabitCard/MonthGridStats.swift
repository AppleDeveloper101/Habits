//
//  MonthGridStats.swift
//  Habits
//
//  Created by Andrey on 05/08/2026.
//

import SwiftUI

struct MonthGridStats: View {
    
    @State private var width: CGFloat = 0.0
    
    let gridSpacing: CGFloat = 8.0
    let cellSpacing: CGFloat = 2.0
    
    var gridModels = (0..<3).map { offset in
        let currentMonth = Calendar.current.dateComponents([.calendar, .year, .month], from: .now).date!
        let date = Calendar.current.date(byAdding: .month, value: offset, to: currentMonth)!
        return MonthGridModel(date: date)
    }
    
    var cellWidth: CGFloat {
        let totalColumnsCount = gridModels.reduce(0) { $0 + $1.columnCount }
        let gridGaps = gridModels.count - 1
        let cellGaps = totalColumnsCount - gridModels.count
        let leanWidth = width - CGFloat(cellGaps) * cellSpacing - CGFloat(gridGaps) * gridSpacing
        return leanWidth / CGFloat(totalColumnsCount)
    }
    
    var body: some View {
        HStack(spacing: gridSpacing) {
            ForEach(gridModels) { model in
                grid(model: model)
            }
        }
        .frame(maxWidth: .infinity)
        .readWidth(into: $width)
    }
    
    @ViewBuilder private func grid(model: MonthGridModel) -> some View {
        HStack(spacing: cellSpacing) {
            ForEach(0..<model.columnCount, id: \.self) { column in
                VStack(spacing: cellSpacing) {
                    ForEach(0..<7) { row in
                        //
                    }
                }
            }
        }
    }
    
}

struct MonthGridModel: Identifiable {
    
    let id: UUID
    let date: Date
    let dates: [Date]
    var columnCount: Int
    
    init(date: Date = .now) {
        self.id = UUID()
        self.date = Calendar.current.dateComponents([.calendar, .year, .month], from: date).date!
        self.dates = {
            let range = Calendar.current.range(of: .day, in: .month, for: date)!
            return range.map { offset in Calendar.current.date(byAdding: .day, value: offset - 1, to: date)! }
        }()
        self.columnCount = Calendar.current.range(of: .weekOfYear, in: .month, for: date)!.count
    }
    
}

#Preview {
    VStack(spacing: 8) {
        CardHeader(.init(emoji: "🌁", title: "Preview Habit"))
        MonthGridStats()
    }
    .border(.pink, width: 1/6)
    .padding(12)
    .background(DefaultStyleShape(RoundedRectangle(cornerRadius: 24), isElevated: true))
    .padding()
}

import Playgrounds

#Playground {
    let currentMonth = Calendar.current.dateComponents([.calendar, .year, .month], from: .now).date!
    let firstWeekday = Calendar.current.firstWeekday
    let monthWeekday = Calendar.current.component(.weekday, from: currentMonth)
    
    _ = (monthWeekday - firstWeekday + 7) % 7
}
