//
//  HabitDeleteButton.swift
//  Habits
//
//  Created by Andrey on 06/05/2026.
//

import SwiftUI

struct HabitDeleteButton: View {
    
    @State private var disengagingTask: Task<Void, Never>?
    @State private var incrementationTask: Task<Void, Never>?
    
    @State private var currentProgress: Int = -1
    
    private let disengagementTimeout = 1.5
    
    @State private var isHolding = false
    
    @State private var fillingAnimationTime: TimeInterval = 0.75
    private let incrementationThreshold: TimeInterval = 1
    @State private var holdTextWidth: CGFloat = 0
    @State private var timer: Timer?
    
    @State private var fillingCapsuleWidth: CGFloat = 0
    
    private let habit: Habit
    private let action: () -> Void
    
    init(_ habit: Habit, _ action: @escaping () -> Void) {
        self.habit = habit
        self.action = action
    }
    
    var body: some View {
        HStack(spacing: 4) {
            if currentProgress == -1 {
                Image(systemName: "trash.circle.fill")
                    .font(.system(size: 26, weight: .regular))
                    .foregroundStyle(.deleteButtonLabel)
                    .transition(.blurReplace)
                
            }
            
            if currentProgress == -1 {
                Text("Delete")
                    .font(.headline)
                    .foregroundStyle(.deleteButtonLabel)
                    .transition(.blurReplace)
            } else {
                ZStack {
                    Text("hold to delete")
                        .font(.headline)
                        .foregroundStyle(.deleteButtonLabel)
                    Text("hold to delete")
                        .font(.headline)
                        .foregroundStyle(.deleteButtonLabelProgressing)
                        .mask {
                            Capsule()
                                .frame(
                                    width: currentProgress == 1 ? 66 : (fillingCapsuleWidth * CGFloat(currentProgress) / 3)
                                )
                        }
                }
                .transition(.blurReplace)
            }
        }
        .frame(height: 44)
        .padding(.leading, currentProgress > -1 ? 12 : 6)
        .padding(.trailing, currentProgress > -1 ? 12 : 8)
        .frame(maxWidth: currentProgress > -1 ? .infinity : nil)
        .background {
            GeometryReader { proxy in
                Capsule()
                    .fill(.deleteButtonLabel)
                    .frame(
                        width: currentProgress == 1 ? 66 : (proxy.size.width * CGFloat(currentProgress) / 3)
                    )
                    .frame(maxWidth: .infinity)
            }
            .readWidth(into: $fillingCapsuleWidth)
        }
        .background(defaultStyleShape(.capsule))
        .contentShape(.capsule)
        .animation(
            currentProgress > 0
            ? .spring(duration: fillingAnimationTime, bounce: 0.25)
            : .smooth(duration: fillingAnimationTime),
            value: currentProgress
        )
        // MARK: - Gesture recognition
        .onLongPressGesture(minimumDuration: 0.125) {
            /// Finger is held on button beyond threshold time
            disengagingTask?.cancel()
            
            if currentProgress < 1 {
                currentProgress = 1
            }
            
            incrementationTask = Task {
                while true {
                    guard currentProgress < 4 else {
                        Task(name: "Action Execution") {
                            incrementationTask?.cancel()
                            currentProgress = -1
                            
                            try? await Task.sleep(for: .seconds(incrementationThreshold))
                            action()
                        }
                        
                        break
                    }
                    
                    try? await Task.sleep(for: .seconds(incrementationThreshold))
                    guard !Task.isCancelled else { return }
                    
                    currentProgress += 1
                }
            }
            
        } onPressingChanged: { isPressed in
            /// Finger touches button
            if isPressed {
                if currentProgress == -1 {
                    disengagingTask?.cancel()
                    
                    disengagingTask = Task {
                        try? await Task.sleep(for: .seconds(disengagementTimeout))
                        guard !Task.isCancelled else { return }
                        currentProgress = -1
                    }
                }
                
                if currentProgress == 0 {
                    disengagingTask?.cancel()
                    
                    disengagingTask = Task {
                        try? await Task.sleep(for: .seconds(disengagementTimeout))
                        guard !Task.isCancelled else { return }
                        currentProgress = -1
                    }
                }
            }
            
            /// Button depressed, finger lifted off
            if !isPressed {
                incrementationTask?.cancel()
                
                if currentProgress == -1 {
                    currentProgress = 0
                }
                
                if currentProgress > 0 {
                    currentProgress = 0
                    disengagingTask = Task {
                        try? await Task.sleep(for: .seconds(disengagementTimeout))
                        guard !Task.isCancelled else { return }
                        currentProgress = -1
                    }
                }
            }
        }
        /////////
        .task {
            print("\n\n\n\n\n\n\n\n\n\n\n\n")
        }
    }
}

#Preview {
    HabitDeleteButton(.init(emoji: "A", title: "A")) {
        print("Action!")
    }
    .padding(.horizontal, 16)
}
