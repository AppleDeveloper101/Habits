//
//  AppService.swift
//  Habits
//
//  Created by Andrey on 27/04/2026.
//

import SwiftUI

final class AppService {
    
    @AppStorage("isOnboardingComplete") private var isOnboardingComplete = false
    
    private init() {}
    
    static func setupNavigationBarAppearance() {
        let appearance = UINavigationBar.appearance()
        
        appearance.titleTextAttributes = [.foregroundColor: UIColor.accent]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.accent]
    }
    
    static func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "isOnboardingComplete")
    }
}
