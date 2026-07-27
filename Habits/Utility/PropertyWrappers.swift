//
//  PropertyWrappers.swift
//  Habits
//
//  Created by Andrey on 27/07/2026.
//

@propertyWrapper struct NonNegative<V> where V: Numeric & Comparable {
    
    var wrappedValue: V {
        didSet {
            wrappedValue = max(.zero, wrappedValue)
        }
    }
    
    init(wrappedValue: V) {
        self.wrappedValue = max(.zero, wrappedValue)
    }
    
}
