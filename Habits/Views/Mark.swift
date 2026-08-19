//
//  Mark.swift
//  Habits
//
//  Created by Andrey on 06/08/2026.
//

import SwiftUI

struct Mark: View {
    
    let state: State
    let scale: CGFloat
    let colors: [Color]
    let cornerRadiusCoefficient: CGFloat
    
    init(state: State = .unchecked) {
        self.state = state
        
        self.scale = switch state {
        case .placeholder: 0.0
        case .unchecked: 0.25
        case .today: 0.5
        case .checked: 1.0
        }
        
        self.colors = switch state {
        case .placeholder: [.clear]
        case .unchecked: [.weekRowEmptyCell]
        case .today, .checked: [.weekRowCellStart, .weekRowCellEnd]
        }
        
        self.cornerRadiusCoefficient = switch state {
        case .checked: markCornerRadiusCoefficient
        default: 0.5
        }
    }
    
    var body: some View {
        GeometryReader { proxy in
            RoundedRectangle(cornerRadius: proxy.size.width * cornerRadiusCoefficient)
                .fill(colors.gradient)
                .scaleEffect(scale)
        }
        .aspectRatio(1.0, contentMode: .fit)
    }
    
}

extension Mark {
    enum State {
        case placeholder
        case unchecked
        case today
        case checked
    }
}

#Preview {
    VStack(spacing: 32.0) {
        Mark(state: .placeholder)
        Mark(state: .unchecked)
        Mark(state: .today)
        Mark(state: .checked)
    }
}
