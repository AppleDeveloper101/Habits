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
    
    func present(_ habit: Habit? = nil) {
        guard !isInteractionBlocked else { return }
        
        if let habit {
            currentContent = .habitInfoSheet(habit)
        } else {
            currentContent = .newHabitSheet
        }
        
        presentationID = UUID()
        
        Task {
            isInteractionBlocked = true
            isPresented = true
            try? await Task.sleep(for: .seconds(0.3))
            isInteractionBlocked = false
        }
        
    }
    
    func dismiss() {
        guard !isInteractionBlocked else { return }
        
        Task {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            isInteractionBlocked = true
            isPresented = false
            try? await Task.sleep(for: .seconds(0.3))
            isInteractionBlocked = false
        }
    }
}

extension ModalManager {
    enum ModalContent: Equatable {
        case newHabitSheet
        case habitInfoSheet(_ habit: Habit)
    }
}
