//
//  ModalPresenter.swift
//  Habits
//
//  Created by Andrey on 26/05/2026.
//

import SwiftUI
import SwiftData // MARK: D?

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
            .overlay {
                ZStack(alignment: .bottom) {
                    /// Transparent gesture recognition area
                    Color.background.opacity(1e-16)
                        .allowsHitTesting(manager.isPresented)
                        .onTapGesture { manager.dismiss() }
                    
                    /// Sheet's content
                    ModalManager.shared.view()
                        .id(manager.presentedHabit?.persistentModelID)
                        .transition(.identity)
                        .contentTransition(.identity)
                        .readHeight(into: $sheetContentHeight)
                        .frame(maxWidth: .infinity, maxHeight: sheetContentHeight)
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
                .ignoresSafeArea(.container, edges: .bottom)
            }
            .animation(.smooth, value: offsetY)
            .animation(.smooth, value: blurRadius)
    }
}



@Observable final class ModalManager {
    
    static let shared = ModalManager()
    
    private init() {}
    
    var isPresented = false
    var presentedHabit: Habit?
    
    func present(_ habit: Habit? = nil) {
        presentedHabit = habit
        isPresented = true
    }
    
    func dismiss() {
        isPresented = false
    }
    
    @ViewBuilder func view() -> some View {
        HabitInfoSheet(presentedHabit)
    }
}
