//
//  SheetMonthHeader.swift
//  Habits
//
//  Created by Andrey on 07/01/2026.
//

import SwiftUI

struct SheetMonthHeader: View {
    private let date: Date
    
    private let calendar = Calendar.current
    
    private var currentYear: Int {
        calendar.component(.year, from: .now)
    }
    
    private var year: Int {
        calendar.component(.year, from: date)
    }
    
    private var monthName: String {
        let monthNumber = calendar.component(.month, from: date)
        return calendar.monthSymbols[monthNumber - 1]
    }
    
    private let monthToYearSpacing: CGFloat = 8
    
    init(date: Date) {
        self.date = date
    }
    
    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: monthToYearSpacing) {
            Text(monthName)
                .font(.title.bold())
                .foregroundStyle(.labelVibrantPrimary)
            
            if year != currentYear {
                Text(year.description)
                    .font(.title3.bold())
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
        .frame(height: 34)
    }
}

#Preview {
    VStack {
        SheetMonthHeader(date: .now)
        SheetMonthHeader(date: .now.addingTimeInterval(-86400 * 365))
    }
    .padding()
}
