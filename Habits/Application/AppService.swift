//
//  AppService.swift
//  Habits
//
//  Created by Andrey on 27/04/2026.
//

import UIKit

final class AppService {
    
    private init() {}
    
    static func setupNavigationBarAppearance() {
        let appearance = UINavigationBar.appearance()
        
        appearance.titleTextAttributes = [.foregroundColor: UIColor.accent]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.accent]
    }
}
