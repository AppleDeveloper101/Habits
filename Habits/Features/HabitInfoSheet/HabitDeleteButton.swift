//
//  HabitDeleteButton.swift
//  Habits
//
//  Created by Andrey on 06/05/2026.
//

import SwiftUI

struct HabitDeleteButton: View {
    
    @State private var buttonEngagementTask: Task<Void, Never>?
    
    @State private var currentProgress: Int = -1
    
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
                        .transition(.blurReplace)
                    //
                    Text("hold to delete")
                        .font(.headline)
                        .foregroundStyle(.deleteButtonLabelProgressing)
                        .transition(.blurReplace)
                        .mask {
                            Capsule()
                                .frame(
                                    width: currentProgress == 1 ? 66 : (fillingCapsuleWidth * CGFloat(currentProgress) / 3)
                                )
                                .animation(
                                    currentProgress > 0
                                    ? .spring(duration: 0.5, bounce: 0.25)
                                    : .smooth(duration: 0.5),
                                    value: currentProgress
                                )
                        }
                    
                }
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
        .animation(
            currentProgress > 0
            ? .spring(duration: 0.5, bounce: 0.25)
            : .smooth(duration: 0.5),
            value: currentProgress
        )
        .onTapGesture {
            buttonEngagementTask?.cancel()
            
            if currentProgress < 3 {
                currentProgress += 1
            } else {
                currentProgress = -1
            }
            
            buttonEngagementTask = Task {
                try? await Task.sleep(for: .seconds(4))
                guard !Task.isCancelled else { return }
                currentProgress = -1
            }
        }
    }
}

#Preview {
    HabitDeleteButton(.init(emoji: "A", title: "A")) {
        print("Action!")
    }
    .padding(.horizontal, 16)
}
