//
//  Mark.swift
//  Habits
//
//  Created by Andrey on 06/08/2026.
//

import SwiftUI

struct Mark: View {
    var body: some View {
        GeometryReader { proxy in
            let cornerRadius = min(proxy.size.width, proxy.size.height) * markCornerRadiusCoefficient
            RoundedRectangle(cornerRadius: cornerRadius)
                .foregroundStyle(.accent)
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

#Preview {
    Mark()
}
