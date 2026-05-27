//
//  ModalPresenter.swift
//  Habits
//
//  Created by Andrey on 26/05/2026.
//

import SwiftUI

struct ModalPresenter: ViewModifier {
    
    private let manager = ModalManager.shared
    
    @State private var sheetContentHeight: CGFloat = 0
    private var offsetY: CGFloat { manager.isPresented ? .zero : sheetContentHeight + sheetPadding }
    
    private var blurRadius: CGFloat { manager.isPresented ? 6 : 0 }
    
    private var sheetPadding: CGFloat = 8
    private let sheetTopEdgeCornerRadius: CGFloat = 38
    
    private var sheetBottomEdgeCornerRadius: CGFloat {
        CGFloat.displayCornerRadius == 0
        ? sheetTopEdgeCornerRadius
        : .displayCornerRadius - sheetPadding
    }
    
    private var sheetShape: UnevenRoundedRectangle {
        UnevenRoundedRectangle(
            topLeadingRadius: sheetTopEdgeCornerRadius,
            bottomLeadingRadius: sheetBottomEdgeCornerRadius,
            bottomTrailingRadius: sheetBottomEdgeCornerRadius,
            topTrailingRadius: sheetTopEdgeCornerRadius,
            style: .continuous
        )
    }
    
    func body(content: Content) -> some View {
        content
            .blur(radius: blurRadius)
            .allowsHitTesting(!manager.isPresented && !manager.isInteractionBlocked)
            .overlay {
                ZStack(alignment: .bottom) {
                    Color.background.opacity(1e-16)
                        .allowsHitTesting(manager.isPresented)
                        .onTapGesture { ModalManager.shared.dismiss() }
                    
                    ZStack(alignment: .top) {
                        switch manager.currentContent {
                        case .newHabitSheet:
                            HabitInfoSheet()
                                .transition(.identity)
                        case .habitInfoSheet(let habit):
                            HabitInfoSheet(habit)
                                .transition(.identity)
                        }
                    }
                    .id(manager.presentationID)
                    .frame(maxWidth: .infinity)
                    .readHeight(into: $sheetContentHeight)
                    .frame(maxHeight: sheetContentHeight, alignment: .bottom)
                    .modify { view in
                        if #available(iOS 26.0, *) {
                            view.glassEffect(.regular.interactive(), in: sheetShape)
                        } else {
                            view.background(.sheetBackground, in: sheetShape)
                        }
                    }
                    .padding([.leading, .trailing, .bottom], sheetPadding)
                    .shadow(color: .black.opacity(0.06), radius: 8)
                    .contentShape(sheetShape)
                    .geometryGroup()
                    .offset(y: offsetY)
                }
            }
            .ignoresSafeArea(.container, edges: .bottom)
            .animation(nil, value: sheetContentHeight)
            .animation(.smooth(duration: 0.35), value: offsetY)
    }
}



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
