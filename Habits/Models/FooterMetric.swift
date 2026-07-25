//
//  FooterMetric.swift
//  Habits
//
//  Created by Andrey on 25/07/2026.
//

import Foundation

struct FooterMetric: Identifiable {
    let id: UUID = UUID()
    var title: String? = nil
    var value: Double
    var valueTitle: String? = nil
    var imageSystemName: String? = nil
    var valueToImageSpacing: CGFloat = 2.0
}
