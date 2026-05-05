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
}
