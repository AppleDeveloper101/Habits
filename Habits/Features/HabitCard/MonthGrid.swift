//
//  MonthGrid.swift
//  Habits
//
//  Created by Andrey on 05/08/2026.
//

import SwiftUI

struct MonthGrid: View {
    
    let displayedDate = Date()
    
    var normalizedDate: Date {
        calendar.date(from: calendar.dateComponents([.year, .month], from: displayedDate))!
    }
    
    private let calendar = Calendar.current
    
    private var placeholderCellsRange: Range<Int> {
        let systemFirstWeekday = calendar.firstWeekday
        let firstWeekdayOfMonth = calendar.component(.weekday, from: normalizedDate)
        let placeholderCellsCount = (firstWeekdayOfMonth - systemFirstWeekday + 7) % 7
        let placeholderCellsRange = .zero..<placeholderCellsCount
        
        return placeholderCellsRange
    }
    
    private var gridDates: [Date] {
        let range = calendar.range(of: .day, in: .month, for: normalizedDate)
        let interval = calendar.dateInterval(of: .month, for: normalizedDate)
        let start = interval!.start
        let end = interval!.end
        
        let dates = range!.map { index in
            calendar.date(byAdding: .day, value: index - 1, to: start)!
        }
        
        return dates
    }
    
    var body: some View {
        VStack {
            ForEach(placeholderCellsRange) { _ in
                Text("|")
            }
            ForEach(gridDates, id: \.self) { date in
                Text(date.formatted(date: .long, time: .omitted))
            }
        }
        .border(.cyan, width: 0.5)
    }
}

#Preview {
    MonthGrid()
}
