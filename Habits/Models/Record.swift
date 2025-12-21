//
//  Record.swift
//  Habits
//
//  Created by Andrey on 21/12/2025.
//

import Foundation
import SwiftData

@Model
class Record {
    private(set) var date: Date
    
    init(date: Date) {
        self.date = date
    }
}
