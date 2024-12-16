//
//  MainMenuOptionsNode.swift
//  Sprint
//
//  Created by Ghaida Atoum on 12/14/24.
//


import Foundation
import SpriteKit

class StartGameButton: SKSpriteNode, VibrateProtocol{}
class StartGameLabel: SKLabelNode{}
class MainMenuOptionsButton: SKSpriteNode, VibrateProtocol{}

class MainMenuNode: SKNode {
    let startGameButton: StartGameButton
    let startGameLabel: StartGameLabel
    let optionsButton: MainMenuOptionsButton
    let soundButton: SoundButton
    
    init(size: CGSize) {
        startGameButton = StartGameButton(imageNamed: Constants.startGameBaseButton)
        startGameButton.scale(to: CGSize(width: 200, height: 100))
        startGameButton.position = CGPoint(x: size.width/2, y: size.height/2.5)
        startGameButton.zPosition = 0
        startGameButton.name = "mainMenuOptionsPlayButton"
        
        startGameLabel = StartGameLabel(text: "Start Game")
        startGameLabel.fontSize = 24
        startGameLabel.position = startGameButton.position
        startGameLabel.fontColor = .black
        startGameLabel.horizontalAlignmentMode = .center
        startGameLabel.verticalAlignmentMode = .baseline
        startGameLabel.fontName = Constants.fontName
        
        optionsButton = MainMenuOptionsButton(imageNamed: Constants.optionsButton)
        optionsButton.scale(to: CGSize(width: size.width / 15, height: size.width / 15))
        //TODO: Dynamic Position
        optionsButton.position = CGPoint(x: size.width - 75, y: size.height - 50)
        optionsButton.zPosition = 0
        optionsButton.name = "mainMenuOptions"
        
        if (SoundManager.shared.soundEnabled) {
            soundButton = SoundButton(imageNamed: Constants.soundButtonOnImage)
        } else {
            soundButton = SoundButton(imageNamed: Constants.soundButtonOffImage)
        }
        
        soundButton.scale(to: CGSize(width: size.width / 15, height: size.width / 15))
        //TODO: Dynamic Position
        soundButton.position = CGPoint(x: 0 + 75, y: size.height - 50)
        soundButton.zPosition = 0
        soundButton.name = "soundButton"
        
        super.init()
        addChild(startGameButton)
        addChild(startGameLabel)
        addChild(optionsButton)
        addChild(soundButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
