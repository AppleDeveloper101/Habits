//
//  FooterMetric.swift
//  Habits
//
//  Created by Andrey on 25/07/2026.
//

import Foundation

struct FooterMetric: Identifiable {
    let id: UUID = UUID()
    
    var header: String? = nil
    var value: Double? = nil
    var valueTitle: String? = nil
    var imageSystemName: String? = nil
    
    @NonNegative var valueDecimalPlaces: Int = 2
    var formattedValue: String? { value?.formatted(.number.precision(.fractionLength(0...valueDecimalPlaces))) }
    
    var valueToImageSpacing: CGFloat = 2.0
}
