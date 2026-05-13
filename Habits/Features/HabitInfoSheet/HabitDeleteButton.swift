//
//  HabitDeleteButton.swift
//  Habits
//
//  Created by Andrey on 06/05/2026.
//

import SwiftUI

struct HabitDeleteButton: View {
    
    private let habit: Habit
    private let action: () -> Void
    
    @State private var incrementationTask: Task<Void, Never>?
    @State private var disengagingTask: Task<Void, Never>?
    
    @State private var isExpansionBlocked = false
    @State private var currentProgress: Int = -1
    
    private let holdToIncrementThreshold: TimeInterval = 1
    private let capsuleAnimationTime: TimeInterval = 0.75
    private let disengagementTimeout = 5
    
    @State private var fillingCapsuleWidth: CGFloat = 0
    @State private var holdTextWidth: CGFloat = 0
    
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
                Text("hold to delete")
                    .font(.headline)
                    .foregroundStyle(.deleteButtonLabel)
                    .transition(.blurReplace)
            }
        }
        .frame(height: 44)
        .padding(.leading, currentProgress > -1 ? 12 : 6)
        .padding(.trailing, currentProgress > -1 ? 12 : 8)
        .frame(maxWidth: currentProgress > -1 ? .infinity : nil)
        .overlay {
            ZStack {
                if currentProgress != -1 {
                    Text("hold to delete")
                        .font(.headline)
                        .foregroundStyle(.deleteButtonLabelProgressing)
                        .transition(.blurReplace)
                } else { Color.clear }
            }
            .mask {
                Capsule()
                    .frame(width: currentProgress == 1 ? 66 : (fillingCapsuleWidth * CGFloat(currentProgress) / 3))
                    .animation(
                        currentProgress > 0
                        ? .spring(duration: capsuleAnimationTime, bounce: 0.25)
                        : .smooth(duration: capsuleAnimationTime),
                        value: currentProgress
                    )
            }
        }
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
        .sensoryFeedback(.increase, trigger: currentProgress) { _, _ in (1...3).contains(currentProgress) }
        .sensoryFeedback(.impact, trigger: currentProgress) { _, _ in currentProgress == 4 }
        .animation(
            currentProgress > 0
            ? .spring(duration: capsuleAnimationTime, bounce: 0.25)
            : .smooth(duration: capsuleAnimationTime),
            value: currentProgress
        )
        .onLongPressGesture(minimumDuration: 0.125) {
            disengagingTask?.cancel()
            
            if currentProgress < 1 {
                currentProgress = 1
            }
            
            incrementationTask = Task {
                while true {
                    guard currentProgress < 4 else {
                        Task(name: "Action Execution") {
                            incrementationTask?.cancel()
                            isExpansionBlocked = true
                            currentProgress = -1
                            
                            try? await Task.sleep(for: .seconds(holdToIncrementThreshold))
                            
                            action()
                        }
                        
                        break
                    }
                    
                    try? await Task.sleep(for: .seconds(holdToIncrementThreshold))
                    guard !Task.isCancelled else { return }
                    
                    currentProgress += 1
                }
            }
            
        } onPressingChanged: { isPressed in
            if isPressed {
                isExpansionBlocked = false
                
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
            if !isPressed {
                if currentProgress == -1 && !isExpansionBlocked {
                    currentProgress = 0
                }
                
                if currentProgress > 0 {
                    incrementationTask?.cancel()
                    currentProgress = 0
                    disengagingTask = Task {
                        try? await Task.sleep(for: .seconds(disengagementTimeout))
                        guard !Task.isCancelled else { return }
                        currentProgress = -1
                    }
                }
            }
        }
    }
}
