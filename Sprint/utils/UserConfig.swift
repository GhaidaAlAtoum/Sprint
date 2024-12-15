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
    
    init() {
        if (isKeyPresentInUserDefaults(key: currentLevelKey)) {
            currentLevel = UserDefaults.standard.integer(forKey: currentLevelKey)
        } else {
            updateCurrentLevel(1)
        }
    }
    
    private func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    func updateCurrentLevel(_ level: Int) {
        self.currentLevel = level
        UserDefaults.standard.set(level, forKey: currentLevelKey)
    }
    
    func getCurrentLevel() -> Int {
        return self.currentLevel
    }
}
