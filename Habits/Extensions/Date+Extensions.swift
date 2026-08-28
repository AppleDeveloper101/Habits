//
//  Date+Extensions.swift
//  Habits
//
//  Created by Andrey on 05/05/2026.
//

import Foundation

extension Date {
    
    static var startOfToday: Date {
        Calendar.current.startOfDay(for: .now)
    }
    
    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }
    
    var amountOfPaddingDays: Int {
        let systemFirstWeekday = Calendar.current.firstWeekday
        let firstWeekdayOfMonth = Calendar.current.component(.weekday, from: self)
        return (firstWeekdayOfMonth - systemFirstWeekday + 7) % 7
    }
    
    var monthDaysRange: [Date] {
        var dates: [Date] = []
        
        let range = Calendar.current.range(of: .day, in: .month, for: self)!
        let firstDayComponents = Calendar.current.dateComponents([.year, .month], from: self)
        var dateToAdd = Calendar.current.date(from: firstDayComponents)!
        
        for _ in 1...range.count {
            dates.append(dateToAdd)
            dateToAdd = Calendar.current.date(byAdding: .day, value: 1, to: dateToAdd)!
        }
        
        return dates
    }
    
    func leavingComponents(_ components: Set<Calendar.Component>) -> Date {
        Calendar.current.dateComponents(components, from: self).date!
    }
    
    func monthName(_ style: FormatStyle.Symbol.Month = .wide) -> String {
        self.formatted(.dateTime.month(style))
    }
    
}
