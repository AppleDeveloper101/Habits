//
//  View+Extensions.swift
//  Habits
//
//  Created by Andrey on 28/04/2026.
//

import Combine
import SwiftUI

extension View {
    
    func modify(@ViewBuilder _ transform: (_ view: Self) -> some View) -> some View {
        transform(self)
    }
    
    func readHeight(into property: Binding<CGFloat>) -> some View {
        self.onGeometryChange(for: CGFloat.self) { proxy in
            proxy.size.height
        } action: { height in
            property.wrappedValue = height
        }
    }
    
    func readWidth(into property: Binding<CGFloat>) -> some View {
        self.onGeometryChange(for: CGFloat.self) { proxy in
            proxy.size.width
        } action: { width in
            property.wrappedValue = width
        }
    }
    
    func receiveKeyboardPresentationState(_ state: Binding<Bool>) -> some View {
        let willShow = NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillShowNotification)
            .map { _ in true }
        
        let willHide = NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ in false }
        
        let publisher = Publishers.Merge(willShow, willHide)
        
        return self.onReceive(publisher) { output in
            state.wrappedValue = output
        }
    }
}
