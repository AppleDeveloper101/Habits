//
//  CardWeekdaysColumn.swift
//  Habits
//
//  Created by Andrey on 23/12/2025.
//

import SwiftUI

struct CardWeekdaysColumn: View {
    private let calendar: Calendar
    
    private var weekdaySymbols: [String] {
        (0..<7).map { index in
            let retrieveIndex = (calendar.firstWeekday - 1 + index) % 7
            return calendar.veryShortWeekdaySymbols[retrieveIndex]
        }
    }
    
    let columnToSeparatorSpacing: CGFloat = 1
    let columnSpacing: CGFloat = 2
    
    init() {
        self.calendar = Calendar.current
    }
    
    var body: some View {
        HStack(spacing: columnToSeparatorSpacing) {
            VStack(spacing: columnSpacing) {
                ForEach(weekdaySymbols, id: \.self) { symbol in
                    Text(symbol)
                        .font(.system(size: 9, weight: .semibold))
                        .foregroundStyle(.labelVibrantPrimary)
                        .frame(width: 16, height: 16)
                }
            }
            
            Capsule()
                .fill(.fillVibrantPrimary)
                .frame(width: 1)
        }
        .fixedSize()
    }
}

#Preview {
    CardWeekdaysColumn()
}
