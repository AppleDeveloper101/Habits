//
//  MonthGrid.swift
//  Habits
//
//  Created by Andrey on 28/08/2026.
//

import SwiftUI

struct MonthGrid: View {
    
    let model: MonthGridViewModel
    
    init(date: Date) {
        self.model = MonthGridViewModel(date: date)
    }
    
    var body: some View {
        VStack(spacing: 4.0) {
            Text(model.monthName)
                .foregroundStyle(.accent)
                .lineLimit(1)
                .font(.footnote)
                .fontWeight(.bold)
                .frame(height: 18.0)
        }
    }
    
}

struct MonthGridViewModel {
    
    let date: Date
    let monthName: String
    
    init(date: Date) {
        self.date = date.leavingComponents([.calendar, .year, .month])
        self.monthName = date.monthName(.wide)
    }
}

#Preview {
    MonthGrid(date: .now)
}
