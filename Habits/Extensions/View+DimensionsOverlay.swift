//
//  View+DimensionsOverlay.swift
//  Habits
//
//  Created by Andrey on 25/01/2026.
//

import SwiftUI

private struct DimensionsOverlay: ViewModifier {
    
    // MARK: - Properties
    
    @State private var labelSize: CGSize = .zero
    
    let alignment: Alignment
    let color: Color
    let fontSize: CGFloat
    let strokeBorderLineWidth: CGFloat
    let isStrokeBorderDisplayed: Bool
    
    private let adjustmentPadding: CGFloat = 4
    private let strokeBorderDashSize: CGFloat = 8
    
    // MARK: - Body
    
    func body(content: Content) -> some View {
        content
            .overlay {
                GeometryReader { proxy in
                    Color.clear
                        .overlay(alignment: alignment) {
                            dimensionsLabel(for: proxy.size)
                        }
                }
            }
            .overlay {
                if isStrokeBorderDisplayed {
                    strokeBorder()
                }
            }
            .zIndex(100)
    }
    
    // MARK: - Subviews
    
    func dimensionsLabel(for size: CGSize) -> some View {
        Text("W:\(size.width.formattedValue) H:\(size.height.formattedValue)")
            .font(.system(size: fontSize, weight: .thin))
            .foregroundStyle(color)
            .monospaced()
            .padding(.horizontal, adjustmentPadding)
            .fixedSize()
            .readSize(into: $labelSize)
    }
    
    func strokeBorder() -> some View {
        StrokeBorderShapeView(
            shape: Rectangle(),
            style: color,
            strokeStyle: .init(
                lineWidth: strokeBorderLineWidth,
                lineCap: .round,
                dash: [strokeBorderDashSize]),
            isAntialiased: true,
            background: EmptyView()
        )
        .mask {
            ZStack(alignment: alignment) {
                Rectangle()
                Rectangle()
                    .frame(width: labelSize.width, height: labelSize.height)
                    .padding(strokeBorderLineWidth)
                    .blendMode(.destinationOut)
            }
        }
    }
}

// MARK: - Helpers

private extension CGFloat {
    static var formatter: NumberFormatter {
        let formatter = NumberFormatter()
        
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        
        return formatter
    }
    
    var formattedValue: String {
        let value = NSNumber(value: self)
        
        return Self.formatter.string(from: value) ?? "?"
    }
}

private extension View {
    func readSize(into property: Binding<CGSize>) -> some View {
        overlay {
            GeometryReader { proxy in
                Color.clear
                    .onAppear {
                        property.wrappedValue = proxy.size
                    }
            }
        }
    }
}

// MARK: - Extensions

extension View {
    func dimensionsOverlay(
        _ alignment: Alignment = .center,
        color: Color = .pink,
        fontSize: CGFloat = 16,
        strokeBorderLineWidth: CGFloat = 1,
        displayStrokeBorder: Bool = true
    ) -> some View {
        self
            .modifier(
                DimensionsOverlay(
                    alignment: alignment,
                    color: color,
                    fontSize: fontSize,
                    strokeBorderLineWidth: strokeBorderLineWidth,
                    isStrokeBorderDisplayed: displayStrokeBorder
                )
            )
    }
}
