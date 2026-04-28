//
//  View+Extensions.swift
//  Habits
//
//  Created by Andrey on 28/04/2026.
//

import SwiftUI

extension View {
    func modify(@ViewBuilder _ transform: (_ view: Self) -> some View) -> some View {
        transform(self)
    }
}
