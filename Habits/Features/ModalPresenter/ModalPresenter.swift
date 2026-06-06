//
//  ModalPresenter.swift
//  Habits
//
//  Created by Andrey on 26/05/2026.
//

import SwiftUI

struct ModalPresenter: ViewModifier {
    
    private let manager = ModalManager.shared
    
    @State private var isKeyboardPresented = false
    @State private var sheetContentHeight: CGFloat = 0
    private var offsetY: CGFloat { manager.isPresented ? .zero : sheetContentHeight + sheetPadding }
    
    private var blurRadius: CGFloat { manager.isPresented ? 6 : 0 }
    
    private var sheetPadding: CGFloat = 8
    private let sheetTopEdgeCornerRadius: CGFloat = 38
    
    private var sheetBottomEdgeCornerRadius: CGFloat {
        CGFloat.displayCornerRadius == 0
        ? sheetTopEdgeCornerRadius
        : isKeyboardPresented ? sheetTopEdgeCornerRadius : (.displayCornerRadius - sheetPadding)
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
            .animation(.smooth(duration: manager.isPresented ? 0.6 : 0.4), value: blurRadius)
            .allowsHitTesting(!manager.isPresented && !manager.isInteractionBlocked)
            .safeAreaInset(edge: .bottom) {
                if manager.isPresented {
                    ZStack(alignment: .bottom) {
                        Color.background.opacity(1e-16)
                            .allowsHitTesting(manager.isPresented)
                            .onTapGesture { ModalManager.shared.dismiss() }
                        
                        ZStack(alignment: .top) {
                            switch manager.currentContent {
                            case .newHabitSheet:
                                HabitInfoSheet()
                            case .habitInfoSheet(let habit):
                                HabitInfoSheet(habit)
                            case .habitCalendarSheet(let habit, let date):
                                HabitCalendarSheet(habit: habit, date: date)
                            }
                        }
                        .transition(.identity)
                        .clipShape(sheetShape)
                        .id(manager.presentationID)
                        .frame(maxWidth: .infinity)
                        .readHeight(into: $sheetContentHeight)
                        .frame(height: sheetContentHeight, alignment: .top)
                        .modify { view in
                            if #available(iOS 26.0, *) {
                                view.glassEffect(.regular.interactive(), in: sheetShape)
                            } else {
                                view
                                    .background(
                                        sheetShape
                                            .fill(.sheetBackground)
                                            .strokeBorder(.sheetStroke, style: .init(lineWidth: 1))
                                    )
                            }
                        }
                        .padding([.leading, .trailing, .bottom], sheetPadding)
                        .shadow(color: .black.opacity(0.06), radius: 8)
                        .contentShape(sheetShape)
                        .geometryGroup()
                    }
                    .transition(.move(edge: .bottom))
                }
            }
            .ignoresSafeArea(.container, edges: .bottom)
            .receiveKeyboardPresentationState($isKeyboardPresented)
            .animation(.none, value: manager.currentContent)
            .animation(.smooth(duration: 0.4), value: sheetBottomEdgeCornerRadius)
            .animation(.snappy(duration: manager.modalAnimationTime), value: manager.isPresented)
    }
}
