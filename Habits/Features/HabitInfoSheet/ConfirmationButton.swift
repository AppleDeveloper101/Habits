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
    
    @State private var progress = -1
    @State private var incrementationTask: Task<Void, Never>?
    @State private var disengagementTask: Task<Void, Never>?
    
    @State private var isCanceled = false
    @GestureState private var isHolding = false
    
    @State private var buttonFrame: CGRect = .zero
    @State private var dragLocation: CGPoint = .zero
    
    var body: some View {
        HStack(spacing: 4) {
            Text(progress == -1 ? "–" : progress.description).contentTransition(.identity) // Image(systemName: "trash.circle.fill")
                .font(.system(size: 26, weight: .regular))
                .foregroundStyle(.deleteButtonLabel)
            Text("Delete")
                .font(.headline)
                .foregroundStyle(.deleteButtonLabel)
        }
        .frame(height: 44)
        .padding(.leading, 6)
        .padding(.trailing, 8)
        .frame(maxWidth: status == .resting ? nil : .infinity)
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
                    dragLocation = drag.location
                    
                    guard !isCanceled else { return }
                    
                    isHolding = true
                    
                    if !buttonFrame.insetBy(dx: -22, dy: -22).contains(dragLocation) && isHolding { isCanceled = true }
                }
                .onEnded { drag in
                    isCanceled = false
                }
        )
        .onChange(of: [isHolding, isCanceled]) { oldValue, newValue in
            if !isHolding || isCanceled { disengage() }
            if isHolding && !isCanceled { engage() }
        }
        
        .animation(.smooth, value: status) // Rfmrt
        .animation(.smooth, value: isHolding) // Rfmrt
        .animation(.smooth, value: isCanceled) // Rfmrt
        
        .onChange(of: isCanceled) { _, newValue in if newValue == true { AudioServicesPlaySystemSound(1100) } } // MARK: DB
        .onChange(of: isHolding) { _, newValue in if newValue == false { AudioServicesPlaySystemSound(1103) } } // MARK: DB
    }
}

private extension ConfirmationButton {
    
    func engage() {
        guard incrementationTask?.isCancelled ?? true else { return }
        
        disengagementTask?.cancel()
        
        incrementationTask = Task {
            if status == .resting { progress = 0 }
            else if status == .engaged { progress = 1 }
        }
    }
    
    func disengage() {
        guard disengagementTask?.isCancelled ?? true else { return }
        
        incrementationTask?.cancel()
        
        disengagementTask = Task {
            progress = 0
            
            try? await Task.sleep(for: .seconds(0.5)) // Order matter
            guard !Task.isCancelled else { return }
            
            progress = -1
        }
    }
    
    enum ButtonState {
        case resting
        case engaged
        case incrementing
        case executingAction
        
        case undefined
    }
    
    var status: ButtonState {
        switch progress {
        case ..<0 : return .resting
        case 0 : return .engaged
        case 0...3: return .incrementing
        case 3...: return .executingAction
            
        default: return .undefined
        }
    }
}

#Preview {
    ConfirmationButton {
        print("💥 Confirmation Action")
    }
    .padding(.horizontal, 32)
}
