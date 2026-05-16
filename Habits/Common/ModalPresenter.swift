//
//  ModalPresenter.swift
//  Habits
//
//  Created by Andrey on 16/05/2026.
//

import SwiftUI

struct ModalPresenter: ViewModifier {
    
    private var isPresented: Bool { SheetManager.shared.currentSheet != nil }
    
    private let sheetTopEdgeCornerRadius: CGFloat = 38
    private var screenEdgesPadding: CGFloat { CGFloat.displayCornerRadius == 0 ? 0 : 8 }
    private var sheetBottomEdgeCornerRadius: CGFloat { .displayCornerRadius - screenEdgesPadding }
    
    var glassShape: some Shape {
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
            .allowsHitTesting(!isPresented)
            .blur(radius: isPresented ? 6 : 0)
            .overlay {
                if isPresented {
                    Color.black.opacity(1e-16)
                        .onTapGesture { SheetManager.shared.dismiss() }
                }
            }
            .overlay(alignment: .bottom) {
                if isPresented {
                    SheetManager.shared.currentSheet?.view
                        .frame(maxWidth: .infinity, maxHeight: 250)
                        .modify { view in
                            if #available(iOS 26.0, *) {
                                view
                                    .glassEffect(.clear.interactive(), in: glassShape)
                            } else {
                                view
                                    .background(.sheetBackground, in: glassShape)
                            }
                        }
                        .shadow(color: .black.opacity(0.06), radius: 8)
                        .padding([.leading, .trailing, .bottom], screenEdgesPadding)
                        .contentShape(glassShape)
                        .transition(.move(edge: .bottom))
                }
            }
            .ignoresSafeArea()
            .animation(.smooth(duration: 0.375), value: isPresented)
    }
}
