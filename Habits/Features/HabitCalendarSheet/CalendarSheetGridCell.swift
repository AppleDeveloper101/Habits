//
//  CalendarSheetGridCell.swift
//  Habits
//
//  Created by Andrey on 15/06/2026.
//

import SwiftUI

struct CalendarSheetGridCell: View {
    
    let date: Date
    let hasRecord: Bool
    let isToday: Bool
    let isDisabled: Bool
    let habit: Habit
    
    @State private var isBackgroundFilled: Bool
    @State private var visualHasRecord: Bool
    @State private var isAwaitingDelay = false
    
    @State private var animationOffset: CGFloat = 0.0
    @State private var scaleX: CGFloat = 0.0
    @State private var scaleY: CGFloat = 0.0
    
    @State private var textScale: CGFloat = 1.0
    @State private var indicatorColor: Color = .clear
    
    init(date: Date, hasRecord: Bool, isToday: Bool, isDisabled: Bool, habit: Habit) {
        self.date = date
        self.hasRecord = hasRecord
        self.isToday = isToday
        self.isDisabled = isDisabled
        self.habit = habit
        self._visualHasRecord = State(initialValue: hasRecord)
        self._isBackgroundFilled = State(initialValue: hasRecord)
    }
    
    var body: some View {
        let indicatorWidth: CGFloat = visualHasRecord ? 16.0 : 6.0
        let indicatorHeight: CGFloat = visualHasRecord ? 4.0 : 6.0
        let cellFillColor: Color = .accent
        
        Text(date.formatted(.dateTime.day(.defaultDigits)))
            .fixedSize()
            .font(.title3.bold())
            .scaleEffect(textScale, anchor: .center)
            .onChange(of: isBackgroundFilled) { _, willFill in
                if willFill {
                    Task {
                        try? await Task.sleep(for: .seconds(isToday ? 0.3 : 0.2))
                        withAnimation(.spring(duration: 0.2)) {
                            textScale = 1.15
                        }
                        try? await Task.sleep(for: .seconds(0.2))
                        withAnimation(.spring(duration: 0.2)) {
                            textScale = 1.0
                        }
                    }
                }
            }
            .foregroundStyle(
                isBackgroundFilled ? .complementary
                : isDisabled ? .sheetCalendarGridCellDisabled : .accent
            )
            .overlay(alignment: .bottom) {
                if isToday {
                    Capsule()
                        .fill(indicatorColor)
                        .frame(width: indicatorWidth, height: indicatorHeight)
                        .animation(.spring(duration: 0.4, bounce: visualHasRecord ? 0.5 : 0.4), value: indicatorWidth)
                        .offset(y: indicatorHeight + 0.5)
                        .onChange(of: isBackgroundFilled) { _, willFill in
                            Task {
                                try? await Task.sleep(for: .seconds(willFill ? 0.3 : 0.15))
                                indicatorColor = willFill ? .complementary : .accent
                            }
                        }
                        .onAppear {
                            indicatorColor = isBackgroundFilled ? .complementary : .accent
                        }
                }
            }
            .frame(width: 44, height: 44)
            .background {
                RoundedRectangle(cornerRadius: 44 * 0.34375)
                    .foregroundStyle(cellFillColor)
                    .scaleEffect(x: scaleX, y: scaleY, anchor: .bottom)
                    .animation(.smooth, value: isBackgroundFilled)
                    .offset(y: animationOffset)
                    .onChange(of: isBackgroundFilled) { _, willFill in
                        Task {
                            withAnimation(isBackgroundFilled ? .spring(.bouncy) : .smooth) {
                                scaleX = isBackgroundFilled ? 1.0 : 0.0
                                scaleY = scaleX
                            }
                            if isToday {
                                withAnimation(.spring) {
                                    animationOffset = willFill ? -20 : 20
                                }
                                try? await Task.sleep(for: .seconds(0.2))
                                withAnimation(.spring(duration: 0.3, bounce: willFill ? 0.5 : 0.3)) {
                                    animationOffset = willFill ? 0 : -4
                                }
                            }
                        }
                    }
                    .onAppear {
                        animationOffset = isToday && !hasRecord ? -4 : 0
                        scaleX = isBackgroundFilled ? 1.0 : 0.0
                        scaleY = scaleX
                    }
            }
            .animation(.smooth, value: visualHasRecord)
            .onTapGesture {
                guard !isDisabled else { return }
                guard !isAwaitingDelay else { return }
                
                DataManager.shared.toggleRecord(for: habit, on: date)
                
                isAwaitingDelay = true
                
                Task {
                    withAnimation(.smooth(duration: 0.35)) {
                        isBackgroundFilled.toggle()
                    }
                    
                    try? await Task.sleep(for: .seconds(0.35))
                    
                    withAnimation(.smooth) {
                        visualHasRecord.toggle()
                    } completion: {
                        isAwaitingDelay = false
                    }
                }
            }
            .onChange(of: hasRecord) { _, newValue in
                if !isAwaitingDelay {
                    visualHasRecord = newValue
                }
            }
    }
}
