//
//  CardMonthHeader.swift
//  Habits
//
//  Created by Andrey on 22/12/2025.
//

import SwiftUI

struct CardMonthHeader: View {
    private let monthName: String
    
    init(date: Date) {
        self.monthName = date.formatted(.dateTime.month(.wide))
    }
    
    var body: some View {
        HStack {
            Text(monthName)
                .foregroundStyle(.labelVibrantPrimary)
                .font(.footnote.bold())
                .frame(height: 18)
            Spacer()
        }
    }
}

#Preview {
    CardMonthHeader(date: .now)
        .padding(.horizontal)
}
