//
//  SheetManager.swift
//  Habits
//
//  Created by Andrey on 03/05/2026.
//

import SwiftUI

@Observable final class SheetManager {
    
    static let shared = SheetManager()
    
    private init() {}
    
    var currentSheet: Sheet? = nil
    
    func present(_ sheet: Sheet) {
        currentSheet = sheet
    }
    
    func dismiss() {
        currentSheet = nil
    }
    
    enum Sheet: Identifiable {
        
        case habitInfoSheet(_ habit: Habit? = nil)
        
        var id: String {
            switch self {
            case .habitInfoSheet(let habit):
                return "HabitInfoSheet-\(habit?.id.uuidString ?? "NewHabit")"
            }
        }
        
        @ViewBuilder var view: some View {
            switch self {
            case .habitInfoSheet(let habit): HabitInfoSheet(habit)
            }
        }
    }
}
