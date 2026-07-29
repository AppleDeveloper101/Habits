//
//  CalendarSheetFooter.swift
//  Habits
//
//  Created by Andrey on 22/07/2026.
//

import SwiftUI

struct CalendarSheetFooter: View {
    
    let metrics: [FooterMetric] // TODO: Check for reactive updates later
    
    private var metricsEnumerated: Array<(offset: Int, element: FooterMetric)> {
        Array(metrics.enumerated())
    }
    
    init(_ metrics: [FooterMetric]) {
        self.metrics = metrics
    }
    
    var body: some View {
        HStack {
            ForEach(metricsEnumerated, id: \.element.id) { index, metric in
                metricView(metric)
                if index != metricsEnumerated.indices.last { Spacer() }
            }
        }
    }
    
    @ViewBuilder private func metricView(_ metric: FooterMetric) -> some View {
        VStack(spacing: 2.0) {
            if let header = metric.header {
                Text(header)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.labelPrimary)
            }
            HStack(spacing: metric.valueToImageSpacing) {
                if let valueWithTitle = metric.formattedValueWithTitle {
                    Text(valueWithTitle) // TODO: Consider adding centering by value title
                }
                if let imageSystemName = metric.imageSystemName {
                    Image(systemName: imageSystemName)
                }
            }
            .font(.system(size: 14, weight: .semibold))
            .foregroundStyle(.sheetCalendarFooterStatsPrimary)
        }
    }
    
}

#Preview {
    CalendarSheetFooter([
        FooterMetric(
            header: "Counter",
            value: 147,
            valueTitle: "Carrots",
            imageSystemName: "carrot",
        ),
        FooterMetric(
            header: "Percentage",
            value: 147/255*100,
            imageSystemName: "percent",
            valueDecimalPlaces: 1,
            valueToImageSpacing: 1.0
        ),
        FooterMetric(
            header: "Category",
            valueTitle: "Flowers",
            imageSystemName: "camera.macro.circle",
            valueDecimalPlaces: 5,
        ),
        FooterMetric(
            header: "Plain Metric",
            value: 609
        )
    ])
    .padding(.horizontal)
}
