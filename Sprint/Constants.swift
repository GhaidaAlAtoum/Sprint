//
//  Constants.swift
//  Sprint
//
//  Created by Ghaida Atoum on 12/14/24.
//

struct Constants {
    static let mainMenuBackgroundImageName:String = "main"
    static let internLevelBackgroundImageName:String = "level0"
    static let baseRedButtonImageName:String = "red_button_0"
    static let playerImageIdleBaseName = "player.Idle_"
    static let playerImageIdleNumberOfImages = 10
    static let leftArrowImageName = "leftArrow"
    static let rightArrowImageName = "rightArrow"
    static let indicatePressed = "pressed"
}

struct PhysicsCategory {
    static let player: UInt32 = 0x1 << 0
    static let ground: UInt32 = 0x1 << 1
}
