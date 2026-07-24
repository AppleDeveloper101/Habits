//
//  MonthGridStats.swift
//  Habits
//
//  Created by Andrey on 22/07/2026.
//

import SwiftUI

struct MonthGridStats: View {
    
    var body: some View {
        
    }
    
    @ViewBuilder private func metricBlock(
        title: String? = nil,
        value: Double,
        valueTitle: String? = nil,
        imageSystemName: String? = nil,
        valueToImageSpacing: CGFloat = 2.0
    ) -> some View {
        VStack(spacing: 2.0) {
            if let title {
                Text(title)
                    .fontWeight(.semibold)
                    .font(.system(size: 12))
                    .foregroundStyle(.labelPrimary)
            }
            HStack(spacing: valueToImageSpacing) {
                HStack(spacing: .zero) {
                    Text(value.description) // TODO: Formatting for decimal part
                    if let valueTitle {
                        Text(valueTitle)
                    }
                }
                if let imageSystemName {
                    Image(systemName: imageSystemName)
                }
            }
            .fontWeight(.semibold)
            .font(.system(size: 14))
            .foregroundStyle(.sheetCalendarFooterStatsPrimary)
        }
    }
    
}

#Preview {
    MonthGridStats()
}
