//
//  SheetDayCell.swift
//  Habits
//
//  Created by Andrey on 06/01/2026.
//

import SwiftUI
import SwiftData

struct SheetDayCell: View {
    @Environment(\.modelContext) private var context
    
    static var placeholder: some View {
        Color.clear.frame(width: 44, height: 44)
    }
    
    private let record: Record?
    private let date: Date
    private let habit: Habit
    
    private let calendar = Calendar.current
    
    private var dayNumber: Int {
        calendar.component(.day, from: date)
    }
    
    private var isToday: Bool {
        calendar.isDate(date, equalTo: .now, toGranularity: .day)
    }
    
    private var isFutureDay: Bool {
        guard let startOfNextDay = calendar.dateInterval(of: .day, for: .now)?.end else {
            fatalError("Failed to obtain startOfNextDay inside SheetDayCell")
        }
        
        return date >= startOfNextDay
    }
    
    private let cellSize: CGFloat = 44
    private let cellShape = RoundedRectangle(cornerRadius: 14)
    
    private var fontColor: Color {
        let color: Color = record == nil ? .labelVibrantPrimary : .white
        let opacity: Double = isFutureDay ? 0.33 : 1.00
        
        return color.opacity(opacity)
    }
    
    init(record: Record?, date: Date, habit: Habit) {
        self.record = record
        self.date = date
        self.habit = habit
    }
    
    var body: some View {
        Text(dayNumber.description)
            .font(.title3.bold())
            .foregroundStyle(fontColor)
            .frame(width: cellSize, height: cellSize)
            .background {
                if isToday && record == nil {
                    StrokeBorderShapeView(
                        shape: cellShape,
                        style: .labelVibrantPrimary,
                        strokeStyle: .init(lineWidth: 2),
                        isAntialiased: true,
                        background: EmptyView()
                    )
                }
                if record != nil {
                    cellShape.fill(.labelVibrantPrimary)
                }
            }
            .overlay(alignment: .bottom) {
                if isToday && record != nil {
                    Capsule()
                        .fill(fontColor)
                        .frame(width: 18, height: 4)
                        .offset(y: -5)
                }
            }
            .onTapGesture {
                do {
                    if let record {
                        context.delete(record)
                    } else {
                        let startOfDay = calendar.startOfDay(for: date)
                        let newRecord = Record(date: startOfDay, habit: habit)
                        context.insert(newRecord)
                    }
                    try context.save()
                } catch {
                    fatalError("Failed to save context from sheet day cell: \(error)")
                }
            }
            .disabled(isFutureDay)
    }
}

#Preview {
    let today = Date.now
    let yesterday = Date.now.addingTimeInterval(-86400)
    let record = Record(date: today, habit: Habit.sample)
    
    SheetDayCell(
        record: nil,
        date: yesterday,
        habit: Habit.sample
    )
    SheetDayCell(
        record: nil,
        date: today,
        habit: Habit.sample
    )
    SheetDayCell(
        record: record,
        date: yesterday,
        habit: Habit.sample
    )
    SheetDayCell(
        record: record,
        date: today,
        habit: Habit.sample
    )
}
