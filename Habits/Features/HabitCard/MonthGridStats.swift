//
//  MonthGridStats.swift
//  Habits
//
//  Created by Andrey on 05/08/2026.
//

//import SwiftUI
//import SwiftData
//
// MARK: - Old
//
//struct MonthGridStats: View {
//
//    @Query private var records: [Record]
//
//    @State private var gridHeight: CGFloat = 0.0
//
//    let habit: Habit
//
//    let weekdaysToGridsSpacing: CGFloat = 4.0
//    let monthHeaderToGridSpacing: CGFloat = 4.0
//    let gridSpacing: CGFloat = 8.0
//    let cellSpacing: CGFloat = 2.0
//
//    var gridModels: [MonthGridModel] {
//        (-2...0).map { offset in
//            let currentMonth = Calendar.current.dateComponents([.calendar, .year, .month], from: .now).date!
//            let date = Calendar.current.date(byAdding: .month, value: offset, to: currentMonth)!
//            return MonthGridModel(date: date)
//        }
//    }
//
//    var totalColumnsCount: Int {
//        gridModels.reduce(0) { $0 + $1.columnCount }
//    }
//
//    var datesWithRecords: Set<Date> {
//        let gridDates = gridModels.reduce([]) { accumulator, model in
//            accumulator + model.dates
//        }
//        let recordDates = records.map { record in
//            Calendar.current.dateComponents([.calendar, .day, .month, .year], from: record.timestamp).date!
//        }
//        let allDates: Set<Date> = Set(gridDates)
//        let allRecordDates: Set<Date> = Set(recordDates)
//        return allDates.intersection(allRecordDates)
//    }
//
//    init(habit: Habit) {
//        self.habit = habit
//
//        let fetchedRecordsHabitID = habit.id
//        let predicate = #Predicate<Record> {
//            $0.habit?.id == fetchedRecordsHabitID
//        }
//
//        _records = Query(filter: predicate)
//    }
//
//    var body: some View {
//        HStack(alignment: .bottom, spacing: weekdaysToGridsSpacing) {
//            weekdaysColumn()
//                .frame(height: gridHeight)
//            GeometryReader { proxy in
//
//                var cellSize: CGFloat {
//                    print("total columns - \(totalColumnsCount)")
//                    let gridGaps = gridModels.count - 1
//                    let cellGaps = totalColumnsCount - gridModels.count
//                    print("Cell gaps - \(cellGaps) | grid gaps - \(gridGaps)")
//                    let leanWidth = proxy.size.width - CGFloat(cellGaps) * cellSpacing - CGFloat(gridGaps) * gridSpacing
//                    print("lean - \(leanWidth)")
//                    print("size – \(leanWidth / CGFloat(totalColumnsCount))")
//                    print("width – \(proxy.size.width)")
//                    return leanWidth / CGFloat(totalColumnsCount)
//                }
//
//                HStack(spacing: gridSpacing) {
//                    ForEach(gridModels) { model in
//                        VStack(alignment: .leading, spacing: monthHeaderToGridSpacing) {
//                            header(date: model.date)
//                            grid(model: model, cellSize: cellSize)
//                                .readHeight(into: $gridHeight)
//                        }
//                        .contentShape(.rect)
//                        .onTapGesture {
//                            ModalManager.shared.present(.habitCalendarSheet(habit, model.date))
//                        }
//                    }
//                }
//                .border(.green)
//            }
//            .border(.purple)
//        }
//    }
//
//    @ViewBuilder private func weekdaysColumn() -> some View {
//
//        let firstWeekday = Calendar.current.firstWeekday - 1
//        let shortSymbols = Calendar.current.veryShortWeekdaySymbols
//        let symbols = shortSymbols[firstWeekday...] + shortSymbols[..<firstWeekday]
//
//        HStack(spacing: 1.0) {
//            VStack(spacing: cellSpacing) {
//                ForEach(symbols, id: \.self) { symbol in
//                    Text(symbol)
//                        .foregroundStyle(.accent)
//                        .font(.system(size: 9))
//                        .fontWeight(.semibold)
//                    //                        .frame(height: cellSize)
//                }
//            }
//            .frame(width: 16.0)
//            Capsule()
//                .fill(.monthGridStatsWeekdaysColumnSeparator)
//                .frame(width: 1.0)
//        }
//    }
//
//    @ViewBuilder private func header(date: Date) -> some View {
//        Text(date.formatted(.dateTime.month(.wide)))
//            .foregroundStyle(.accent)
//            .font(.system(size: 14))
//            .fontWeight(.semibold)
//            .lineLimit(1)
//    }
//
//    //        @ViewBuilder private func grid(model: MonthGridModel) -> some View {
//    //            HStack(spacing: cellSpacing) {
//    //                ForEach(0..<model.columnCount, id: \.self) { column in
//    //                    VStack(spacing: cellSpacing) {
//    //                        ForEach(0..<7) { row in
//    //                            let cellNumber = (column * 7 + row + 1)
//    //                            let dateIndex = 0 - model.paddingCellsCount + cellNumber - 1
//    //
//    //                            if model.dates.indices.contains(dateIndex) {
//    //                                if datesWithRecords.contains(model.dates[dateIndex]) {
//    //                                    Mark(state: .checked)
//    //                                } else if model.dates[dateIndex].isToday {
//    //                                    Mark(state: .today)
//    //                                } else {
//    //                                    Mark()
//    //                                }
//    //                            } else {
//    //                                Mark(state: .placeholder)
//    //                            }
//    //                        }
//    //                    }
//    //                    .frame(width: columnWidth)
//    //                }
//    //            }
//    //        }
//
//    @ViewBuilder private func grid(model: MonthGridModel, cellSize: CGFloat) -> some View {
//
//        let paddingCellsCount = model.paddingCellsCount
//        let dates = model.dates
//        let rows: [GridItem] = Array(repeating: GridItem(.fixed(cellSize), spacing: cellSpacing), count: 7)
//
//        LazyHGrid(rows: rows, alignment: .top, spacing: cellSpacing) {
//            ForEach(0..<paddingCellsCount, id: \.self) { _ in
//                Mark(state: .unchecked)
//            }
//            ForEach(dates, id: \.self) { date in
//                Mark(state: .checked)
//            }
//        }
//        .border(.pink)
//        .overlay {
//            Text(model.columnCount.description).font(.title3).foregroundStyle(.red)
//        }
//    }
//
//}
//
//struct MonthGridModel: Identifiable {
//
//    let id: UUID
//    let date: Date
//    var dates: [Date]
//    let columnCount: Int
//    let paddingCellsCount: Int
//
//    init(date: Date = .now) {
//        self.id = UUID()
//        self.date = Calendar.current.dateComponents([.calendar, .year, .month], from: date).date!
////                self.dates = {
////                    let range = Calendar.current.range(of: .day, in: .month, for: date)!
////                    return range.map { offset in Calendar.current.date(byAdding: .day, value: offset - 1, to: date)! }
////                }()
//        let random = Int.random(in: 14...35)
//        self.dates = (0..<random).map({ index in
//            Calendar.current.date(byAdding: .day, value: index, to: .now)!
//        })
//        self.paddingCellsCount = {
//            let currentMonth = Calendar.current.dateComponents([.calendar, .year, .month], from: date).date!
//            let firstWeekday = Calendar.current.firstWeekday
//            let monthWeekday = Calendar.current.component(.weekday, from: currentMonth)
//            return (monthWeekday - firstWeekday + 7) % 7
//        }()
////                self.columnCount = Calendar.current.range(of: .weekOfYear, in: .month, for: date)!.count
//        self.columnCount = Int(ceil(Double(dates.count + paddingCellsCount) / 7.0))
//    }
//
//}
//
//#Preview {
//    let habit = Habit(emoji: "🌁", title: "Preview Habit")
//
//    ScrollView {
//        VStack(spacing: 8) {
//            CardHeader(habit)
//            MonthGridStats(habit: habit)
//        }
//        .padding(12)
//        .background(DefaultStyleShape(RoundedRectangle(cornerRadius: 24), isElevated: true))
//        .padding()
//    }
//}

// MARK: - Reference

//struct Grid: View {
//
//    let cellsCount: Int
//    let rows: [GridItem] = Array(repeating: GridItem(.fixed(16.0), spacing: 4.0), count: 7)
//
//    init() {
//        cellsCount = Int.random(in: 21...35)
//    }
//
//    var body: some View {
//        LazyHGrid(rows: rows, alignment: .top, spacing: 4.0) {
//            ForEach(0..<cellsCount, id: \.self) { index in
//                Text("\(index + 1)")
//                    .font(.system(size: 12))
//                    .foregroundColor(.primary)
//                    .frame(width: 16.0, height: 16.0)
//            }
//        }
//        // (7 cells * 16pt) + (6 row spacings * 4pt) = 136pt
//        .frame(height: 136.0)
//    }
//}

// MARK: - New

import SwiftUI

struct MonthGridStats: View {
    
    private let monthsCount = 3
    private let gridModels: [MonthGridViewModel]
    
    private let cellSpacing: CGFloat = 2.0
    private let gridSpacing: CGFloat = 8.0
    private let columnsCount: Int
    private let cellGapsCount: Int
    private let gridGapsCount: Int
    private let spacingWidth: CGFloat
    
    @State private var gridsContainerWidth: CGFloat = 0.0
    var leanWidth: CGFloat { gridsContainerWidth - spacingWidth }
    var cellSize: CGFloat { leanWidth / Double(columnsCount) }
    
    // ---
    
    init() {
        self.gridModels = (0..<monthsCount).map { _ in
            MonthGridViewModel()
        }
        self.columnsCount =  gridModels.reduce(0) { $0 + $1.columnsCount }
        self.cellGapsCount = columnsCount - monthsCount
        self.gridGapsCount = monthsCount - 1
        self.spacingWidth = cellSpacing * Double(cellGapsCount) + gridSpacing * Double(gridGapsCount)
    }
    
    var body: some View {
        HStack(spacing: 4.0) {
            //////
            Rectangle()
                .frame(width: 24)
            //////
            
            HStack(spacing: gridSpacing) {
                ForEach(gridModels) { model in
                    grid(model: model, cellSize: cellSize)
                        .border(.blue.opacity(1/3))
                }
            }
            .frame(maxWidth: .infinity)
            .readWidth(into: $gridsContainerWidth)
            .border(.green.opacity(1/2))
        }
    }
    
    @ViewBuilder private func grid(model: MonthGridViewModel, cellSize: CGFloat) -> some View {
        Grid(horizontalSpacing: cellSpacing, verticalSpacing: cellSpacing) {
            ForEach(0..<7, id: \.self) { row in
                GridRow {
                    ForEach(0..<model.columnsCount, id: \.self) { column in
                        Mark()
                            .border(.black.opacity(0.4))
                    }
                }
                .frame(width: cellSize)
            }
        }
    }
    
}

private struct MonthGridViewModel: Identifiable {
    
    let id: UUID
    let cellsCount: Int
    let columnsCount: Int
    let paddingCellsCount: Int
    
    init() {
        self.id = UUID()
        self.cellsCount = Int.random(in: 2...54)
        self.columnsCount = Int(ceil(Double(cellsCount) / 7))
        self.paddingCellsCount = Int.random(in: 0...6)
    }
    
}

#Preview {
    ScrollView {
        VStack(spacing: 8.0) {
            MonthGridStats()
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).applyDefaultStyling())
        }
        .border(.purple, width: 1)
        .padding(.horizontal)
    }
}
