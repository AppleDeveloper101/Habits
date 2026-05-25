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
    @State private var fillingCapsuleWidth: CGFloat = .zero
    
    var body: some View {
        HStack(spacing: 4) {
            if status == .resting {
                Image(systemName: "trash.circle.fill")
                    .font(.system(size: 26, weight: .regular))
                    .foregroundStyle(.deleteButtonLabel)
                    .transition(.blurReplace)
            }
            
            if status == .resting {
                Text("Delete")
                    .font(.headline)
                    .foregroundStyle(.deleteButtonLabel)
                    .transition(.blurReplace)
            } else {
                Text("hold to delete")
                    .font(.headline)
                    .foregroundStyle(.deleteButtonLabel)
                    .transition(.blurReplace)
            }
        }
        .frame(height: 44)
        .padding(.leading, 6)
        .padding(.trailing, 8)
        .frame(maxWidth: status == .resting ? nil : .infinity)
//        .overlay {
//            Text("hold to delete")
//                .fixedSize()
//                .font(.headline)
//                .foregroundStyle(.deleteButtonLabelProgressing)
//                .transition(.blurReplace)
//                .mask {
//                    Capsule()
//                        .frame(width: fillingCapsuleWidth)
//                }
//        }
        .overlay {
            ZStack {
                if status == .resting {
                    Text("Delete")
                        .font(.headline)
                        .foregroundStyle(.deleteButtonLabel)
                        .transition(.blurReplace)
                } else {
                    Text("hold to delete")
                        .font(.headline)
                        .foregroundStyle(.deleteButtonLabelProgressing)
                        .transition(.blurReplace)
                }
            }
            .mask {
                Capsule()
                    .frame(width: fillingCapsuleWidth)
            }
        }
        .background {
            DefaultStyleShape(.capsule)
            
            GeometryReader { proxy in
                Capsule()
                    .foregroundStyle(.deleteButtonLabel)
                    .frame(width: proxy.size.width * CGFloat(progress) / 3)
                    .readWidth(into: $fillingCapsuleWidth)
                    .frame(maxWidth: .infinity)
            }
        }
        .contentShape(.capsule)
        .allowsHitTesting(!isHolding)
        .onGeometryChange(for: CGRect.self) { proxy in
            proxy.frame(in: .global)
        } action: { newFrame in
            
            buttonFrame = newFrame
            
            guard isHolding && !isCanceled else { return }
            
            if !buttonFrame.insetBy(dx: -22, dy: -22).contains(dragLocation) && isHolding {
                isCanceled = true
                AudioServicesPlaySystemSound(1100)
            }
        }
        .gesture(
            DragGesture(minimumDistance: .zero, coordinateSpace: .global)
                .updating($isHolding) { drag, isHolding, _ in
                    dragLocation = drag.location
                    
                    guard !isCanceled else { return }
                    
                    let deltaX = abs(drag.translation.width)
                    let deltaY = abs(drag.translation.height)
                    
                    if deltaX > 0 || deltaY > 0 {
                        if !buttonFrame.insetBy(dx: -22, dy: -22).contains(dragLocation) {
                            isCanceled = true
                            AudioServicesPlaySystemSound(1104)
                        }
                    }
                    
                    guard !isHolding else { return }
                    
                    isHolding = true
                }
                .onEnded { drag in
                    isCanceled = false
                }
        )
        .onChange(of: [isHolding, isCanceled]) {
            if isHolding && !isCanceled { engage() }
            if !isHolding || isCanceled { disengage() }
        }
        .animation(.smooth, value: fillingCapsuleWidth)
        .animation(.smooth, value: progress)
        .animation(.smooth, value: status)
        .animation(.smooth, value: isHolding)
        .animation(.smooth, value: isCanceled)
    }
}

private extension ConfirmationButton {
    
    func engage() {
        guard incrementationTask?.isCancelled ?? true else { return }
        
        disengagementTask?.cancel()
        
        incrementationTask = Task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(status == .resting ? 0.085 : (status == .engaged ? 0 : 1)))
                guard !Task.isCancelled else { return }
                if progress == 3 { disengage(shouldExecuteAction: true) ; break }
                progress += 1
            }
        }
    }
    
    func disengage(shouldExecuteAction: Bool = false) {
        guard disengagementTask?.isCancelled ?? true else { return }
        
        incrementationTask?.cancel()
        
        if shouldExecuteAction {
            disengagementTask = Task {
                AudioServicesPlaySystemSound(1111)
                progress = -1
                action()
            }
        } else {
            disengagementTask = Task {
                progress = 0
                try? await Task.sleep(for: .seconds(4)) // Disengagement timeout
                guard !Task.isCancelled else { return }
                progress = -1
            }
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
