//
//  Constants.swift
//  Sprint
//
//  Created by Ghaida Atoum on 12/14/24.
//

struct Constants {
    static let mainMenuBackgroundImageName:String = "main"
    static let internLevelBackgroundImageName:String = "level0_top"
    static let startGameBaseButton:String = "button"
    static let playerImageIdleBaseName = "player.Idle_"
    static let playerImageWalkBaseName = "player.Walk_"
    static let playerImageJumpBaseName = "player.jump_"
    static let playerIdleAttackBaseName = "player.IdleAttack_"
    static let playerRunAttackNumberOfImages = 10
    static let playerRunAttackBaseName = "player.RunAttack_"
    static let playerIdleAttackNumberOfImages = 10
    static let playerImageIdleNumberOfImages = 10
    static let playerImageWalkNumberOfImages = 10
    static let playerImageJumpNumberOfImages = 15
    static let leftArrowImageName = "leftArrow"
    static let rightArrowImageName = "rightArrow"
    static let indicatePressed = "_pressed"
    static let controlBackground = "bottom"
    static let circularControButton = "circularButton"
    static let fontName = "ARCADECLASSIC"
    
    static let optionsButton:String = "configButton"
    
    
    static let optionsSceneBackground:String = "options_menu_backgroun"
    static let backButtonName:String = "backButton"
    
    static let toggleOnImage:String = "toggle_on"
    static let toggleOffImage:String = "toggle_off"
    static let toggleTransitionImage:String = "toggle_transition"
    
    
    static let soundButtonOnImage:String = "soundButton"
    static let soundButtonOffImage:String = "soundButton_off"
    static let soundButtonPressedImage:String = "soundButton_pressed"
    
    static let pauseButton:String = "pauseButton"
    static let resumeButton:String = "resumeButton"
    static let homeButton:String = "homeButton"
    static let closeButton:String = "closeButton"
    
    static let playerLostBaseName = "player.lost_"
    static let playerLostNumberOfImages = 10
    
    static let playerWonBaseName = "player.won_"
    static let playerWonNumberOfImages = 10
    
    static let stressHigh = "stressHigh"
    static let cushedIt = "curshedIt"

    
    
}

struct PhysicsCategory {
    static let none: UInt32 = 0
    static let player: UInt32 = 0b1
    static let ground: UInt32 = 0b10
    static let projictile: UInt32 = 0b100
    static let enemy: UInt32 = 0b1000
}
