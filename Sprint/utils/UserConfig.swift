//
//  UserConfig.swift
//  Sprint
//
//  Created by Ghaida Atoum on 12/14/24.
//

import Foundation

class UserConfig {
    static let shared: UserConfig = UserConfig()
    
    var currentLevel:Int = 1
    let currentLevelKey = "current_level"
    
    var vibration: Bool
    let vibrationEnabledKey:String = "vibration_enabled"
    var paused: Bool
    
    init() {
        self.vibration = true
        self.paused = false
        self.currentLevel = 1
        if (isKeyPresentInUserDefaults(key: currentLevelKey)) {
            currentLevel = UserDefaults.standard.integer(forKey: currentLevelKey)
        } else {
            updateCurrentLevel(self.currentLevel)
        }
        
        if (isKeyPresentInUserDefaults(key: vibrationEnabledKey)) {
            vibration = UserDefaults.standard.bool(forKey: vibrationEnabledKey)
        } else {
            trackVibrationValue()
        }
    }
    
    private func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    func updateCurrentLevel(_ level: Int) {
        self.currentLevel = level
        UserDefaults.standard.set(level, forKey: currentLevelKey)
    }
    
    func togglePause() {
        self.paused.toggle()
    }
    
    func toggleVibration() {
        self.vibration.toggle()
    }
    
    func isVibrationEnabled() -> Bool {
        return self.vibration
    }
    
    func isPaused() -> Bool {
        return self.paused
    }
    
    private func trackVibrationValue() {
        UserDefaults.standard.set(vibration, forKey: vibrationEnabledKey)
    }
    
    func getCurrentLevel() -> Int {
        return self.currentLevel
    }
}
