//
//  SheetWeekdaysColumn.swift
//  Habits
//
//  Created by Andrey on 07/01/2026.
//

import SwiftUI

struct SheetWeekdaysColumn: View {
    private let calendar = Calendar.current
    
    private var weekdaySymbols: [String] {
        (0..<7).map { index in
            let retrieveIndex = (calendar.firstWeekday - 1 + index) % 7
            return calendar.veryShortStandaloneWeekdaySymbols[retrieveIndex]
        }
    }
    
    private let columnToSeparatorSpacing: CGFloat = 6
    private let columnSpacing: CGFloat = 8
    
    var body: some View {
        HStack(spacing: columnToSeparatorSpacing) {
            VStack(spacing: columnSpacing) {
                ForEach(weekdaySymbols, id: \.self) { symbol in
                    Text(symbol)
                        .font(.title3.bold())
                        .foregroundStyle(.labelVibrantSecondary)
                        .frame(width: 22, height: 44)
                }
            }
            
            Capsule()
                .fill(.labelVibrantQuaternary)
                .frame(width: 2)
        }
        .fixedSize()
    }
}

#Preview {
    SheetWeekdaysColumn()
}
