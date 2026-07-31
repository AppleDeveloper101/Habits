//
//  FooterMetric.swift
//  Habits
//
//  Created by Andrey on 25/07/2026.
//

import SwiftUI

struct FooterMetric: Identifiable {
    let id: UUID = UUID()
    
    var header: String? = nil
    var metric: LocalizedStringResource? = nil
    var imageSystemName: String? = nil
    
    var metricToImageSpacing: CGFloat = 2.0
}
