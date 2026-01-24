//
//  CardDayCell.swift
//  Habits
//
//  Created by Andrey on 21/12/2025.
//

import SwiftUI

struct CardDayCell: View {
    static var placeholder: some View {
        Color.clear.frame(width: 16, height: 16)
    }
    
    private let hasRecord: Bool
    private let isToday: Bool
    
    private let cellSize: CGFloat = 16
    
    private var markSize: CGFloat {
        if hasRecord {
            return cellSize
        } else {
            return isToday ? 8 : 4
        }
    }
    
    private var markCornerRadius: CGFloat {
        return hasRecord ? 5.5 : .infinity
    }
    
    private var markFillColor: Color {
        return (hasRecord || isToday) ? .labelVibrantPrimary : .fillVibrantSecondary
    }
    
    init(hasRecord: Bool, isToday: Bool) {
        self.hasRecord = hasRecord
        self.isToday = isToday
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: markCornerRadius)
            .fill(markFillColor)
            .frame(width: markSize, height: markSize)
            .frame(width: cellSize, height: cellSize)
    }
}

#Preview {
    CardDayCell(hasRecord: false, isToday: false)
    CardDayCell(hasRecord: false, isToday: true)
    CardDayCell(hasRecord: true, isToday: true)
}
