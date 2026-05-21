//
//  ConfirmationButton.swift
//  Habits
//
//  Created by Andrey on 20/05/2026.
//

import SwiftUI
import AudioToolbox // MARK: DB

struct ConfirmationButton: View {
    
    private var action: () -> Void
    
    init(_ action: @escaping () -> Void) {
        self.action = action
    }
    
    @State private var isCanceled = false
    @GestureState private var isHolding = false
    
    @State private var buttonFrame: CGRect = .zero
    @State private var dragLocation: CGPoint = .zero
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "trash.circle.fill")
                .font(.system(size: 26, weight: .regular))
                .foregroundStyle(.deleteButtonLabel)
            Text("isHolding: \(isHolding ? "+" : "-") | isCanceled: \(isCanceled ? "+" : "-")") // MARK: R // Text("Delete")
                .font(.caption).contentTransition(.identity) // MARK: R // .font(.headline)
                .foregroundStyle(.deleteButtonLabel)
        }
        .frame(height: 44)
        .padding(.leading, 6)
        .padding(.trailing, 8)
        .frame(maxWidth: isHolding && !isCanceled ? .infinity : nil)
        .background { DefaultStyleShape(.capsule) }
        .onGeometryChange(for: CGRect.self) { proxy in
            proxy.frame(in: .global)
        } action: { newFrame in
            
            buttonFrame = newFrame
            
            guard isHolding && !isCanceled else { return }
            
            if !buttonFrame.insetBy(dx: -22, dy: -22).contains(dragLocation) && isHolding { isCanceled = true }
        }
        .gesture(
            DragGesture(minimumDistance: .zero, coordinateSpace: .global)
                .updating($isHolding) { drag, isHolding, _ in
                    isHolding = true
                    
                    dragLocation = drag.location
                    
                    guard !isCanceled else { return }
                    
                    if !buttonFrame.insetBy(dx: -22, dy: -22).contains(dragLocation) && isHolding { isCanceled = true }
                    
                    guard !isHolding else { return }
                }
                .onEnded { drag in
                    isCanceled = false
                }
        )
        
        .animation(.smooth, value: isHolding)
        .animation(.smooth, value: isCanceled)
        
        .onChange(of: isCanceled) { _, newValue in if newValue == true { AudioServicesPlaySystemSound(1100) } } // MARK: DB
        .onChange(of: isHolding) { _, newValue in if newValue == false { AudioServicesPlaySystemSound(1103) } } // MARK: DB
    }
}

#Preview {
    ConfirmationButton {
        print("💥 Confirmation Action")
    }
    .padding(.horizontal, 32)
}
