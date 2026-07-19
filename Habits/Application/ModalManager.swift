//
//  ModalManager.swift
//  Habits
//
//  Created by Andrey on 28/05/2026.
//

import SwiftUI

@Observable final class ModalManager {
    
    static let shared = ModalManager()
    
    private init() {}
    
    var isPresented = false
    var isInteractionBlocked = false
    var currentContent: ModalContent = .newHabitSheet
    var presentationID = UUID()
    
    let modalAnimationTime: Double = 0.5
    var interactionBlockingTime: Double { modalAnimationTime }
    
    func present(_ modal: ModalContent) {
        guard !isInteractionBlocked else { return }
        
        switch modal {
        case .newHabitSheet:
            currentContent = .newHabitSheet
        case .habitInfoSheet(let habit):
            currentContent = .habitInfoSheet(habit)
        case .habitCalendarSheet(let habit, let date):
            currentContent = .habitCalendarSheet(habit, date)
        }
        
        presentationID = UUID()
        
        Task {
            isInteractionBlocked = true
            isPresented = true
            try? await Task.sleep(for: .seconds(interactionBlockingTime))
            isInteractionBlocked = false
        }
    }
    
    func dismiss() {
        guard !isInteractionBlocked else { return }
        
        Task {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            isInteractionBlocked = true
            isPresented = false
            try? await Task.sleep(for: .seconds(interactionBlockingTime))
            isInteractionBlocked = false
        }
    }
}

extension ModalManager {
    enum ModalContent: Equatable {
        case newHabitSheet
        case habitInfoSheet(_ habit: Habit)
        case habitCalendarSheet(_ habit: Habit, _ date: Date)
    }
}
