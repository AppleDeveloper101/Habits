//
//  MonthGrid.swift
//  Habits
//
//  Created by Andrey on 05/08/2026.
//

import SwiftUI

struct MonthGrid: View {
    
    let date: Date
    
    private let calendar = Calendar.current
    
    private var normalizedDate: Date {
        calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
    }
    
    private var placeholderCellsCount: Int {
        let systemFirstWeekday = calendar.firstWeekday
        let firstWeekdayOfMonth = calendar.component(.weekday, from: normalizedDate)
        let placeholderCellsCount = (firstWeekdayOfMonth - systemFirstWeekday + 7) % 7
        return placeholderCellsCount
    }
    
    private var cells: [Date?] {
        let firstDateToAdd = calendar.dateInterval(of: .month, for: normalizedDate)!.start
        let range = calendar.range(of: .day, in: .month, for: normalizedDate)!
        let nils = Array<Date?>(repeating: nil, count: placeholderCellsCount)
        
        var days: [Date?] = range.map { dayIndex in
            let dateToAdd = calendar.date(byAdding: .day, value: dayIndex - 1, to: firstDateToAdd)!
            print(dateToAdd.formatted(date: .complete, time: .omitted))
            return dateToAdd
        }
        days.insert(contentsOf: nils, at: .zero)
        
        return days
    }
    
    private var columnsCount: Int {
        Int(ceil(Double(cells.count) / 7.0))
    }
    
    // MARK: - Initializers
    
    init() {
        self.date = .now
    }
    
    init(date: Date) {
        self.date = date
    }
    
    // MARK: - Body
    
    var body: some View {
        HStack(alignment: .top, spacing: 2) {
            ForEach(0..<columnsCount, id: \.self) { columnIndex in
                VStack(alignment: .center, spacing: 2) {
                    let columnFirstDateIndex = columnIndex * 7
                    ForEach(columnFirstDateIndex..<columnFirstDateIndex + 7, id: \.self) { cellIndex in
                        if cells.indices.contains(cellIndex) {
                            if cells[cellIndex] != nil {
                                Mark()
                            } else {
                                Mark().opacity(.zero)
                            }
                        }
                    }
                }
            }
        }
        .frame(width: 20.0  * CGFloat(columnsCount)) // Equal distribution
    }
    
}

#Preview {
    HStack(spacing: 8) {
        MonthGrid(date: .now)
        MonthGrid(date: Calendar.current.date(byAdding: .month, value: 1, to: .now)!)
        MonthGrid(date: Calendar.current.date(byAdding: .month, value: 2, to: .now)!)
    }
}
