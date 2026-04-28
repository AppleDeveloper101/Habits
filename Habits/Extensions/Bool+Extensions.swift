//
//  Bool+Extensions.swift
//  Habits
//
//  Created by Andrey on 28/04/2026.
//

extension Bool {
    static var isLiquidGlassAvailable: Self {
        if #available(iOS 26.0, *) {
            true
        } else {
            false
        }
    }
}
