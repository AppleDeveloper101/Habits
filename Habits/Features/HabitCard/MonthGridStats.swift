//
//  MonthGridStats.swift
//  Habits
//
//  Created by Andrey on 22/07/2026.
//

import SwiftUI

struct MonthGridStats: View {
    
    @State var metrics: [FooterMetric]
    
    private var metricsEnumerated: Array<(offset: Int, element: FooterMetric)> {
        Array(metrics.enumerated())
    }
    
    var body: some View {
        HStack {
            ForEach(metricsEnumerated, id: \.element.id) { index, metric in
                metricBlock(metric)
                if index != metricsEnumerated.indices.last { Spacer() }
            }
        }
    }
    
    @ViewBuilder private func metricBlock(_ metric: FooterMetric) -> some View {
        VStack(spacing: 2.0) {
            if let title = metric.title {
                Text(title)
                    .fontWeight(.semibold)
                    .font(.system(size: 12))
                    .foregroundStyle(.labelPrimary)
            }
            HStack(spacing: metric.valueToImageSpacing) {
                HStack(spacing: .zero) {
                    Text(metric.value.description) // TODO: Formatting for decimal part
                    // TODO: Natural spacing between metric value and title; concatenation?
                    if let valueTitle = metric.valueTitle {
                        Text(valueTitle)
                    }
                }
                if let imageSystemName = metric.imageSystemName {
                    Image(systemName: imageSystemName)
                }
            }
            .fontWeight(.semibold)
            .font(.system(size: 14))
            .foregroundStyle(.sheetCalendarFooterStatsPrimary)
        }
    }
    
}

// TODO: Better example

#Preview {
    MonthGridStats(
        metrics: [
            FooterMetric(
                title: "Test",
                value: 47.43,
                imageSystemName: "percent",
                valueToImageSpacing: 0.0
            ),
            FooterMetric(
                title: "Tset",
                value: 12,
                valueTitle: "Cirtem",
                imageSystemName: "leaf",
            ),
        ]
    )
    .padding(.horizontal, 48)
}
