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
            .allowsHitTesting(!manager.isPresented && !manager.isInteractionBlocked)
            .safeAreaInset(edge: .bottom) {
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
                    .frame(height: sheetContentHeight, alignment: .top)
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
            .animation(.smooth(duration: 0.3), value: sheetBottomEdgeCornerRadius)
            .receiveKeyboardPresentationState($isKeyboardPresented)
    }
}
