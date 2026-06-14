//
//  String+Extensions.swift
//  Habits
//
//  Created by Andrey on 14/06/2026.
//

extension String {
    
    var isDefaultEmoji: Bool {
        self == "🎯"
    }
    
    static var defaultEmoji: Self {
        "🎯"
    }
}
