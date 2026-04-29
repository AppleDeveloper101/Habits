//
//  Record.swift
//  Habits
//
//  Created by Andrey on 29/04/2026.
//

import Foundation
import SwiftData

@Model class Record {
    
    var timestamp: Date
    
    init() {
        self.timestamp = .now
    }
}
