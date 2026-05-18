//
//  ModalPresenter.swift
//  Habits
//
//  Created by Andrey on 16/05/2026.
//

import SwiftUI

struct ModalPresenter: ViewModifier {
    
    private var isPresented: Bool { SheetManager.shared.currentSheet != nil }
    
    @State private var contentHeight: CGFloat = 0
    
    private var sheetPadding: CGFloat = 8
    private let sheetTopEdgeCornerRadius: CGFloat = 38
    private var sheetBottomEdgeCornerRadius: CGFloat {
        CGFloat.displayCornerRadius == 0
        ? sheetTopEdgeCornerRadius
        : .displayCornerRadius - sheetPadding
    }
    
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
                SheetManager.shared.currentSheet?.view
                    .readHeight(into: $contentHeight)
                    .frame(maxWidth: .infinity, maxHeight: contentHeight)
                    .modify { view in
                        if #available(iOS 26.0, *) {
                            view
                                .glassEffect(.regular.interactive(), in: glassShape)
                        } else {
                            view
                                .background(.sheetBackground, in: glassShape)
                        }
                    }
                    .shadow(color: .black.opacity(0.06), radius: 8)
                    .padding([.leading, .trailing, .bottom], sheetPadding)
                    .contentShape(glassShape)
            }
            .ignoresSafeArea()
    }
}
