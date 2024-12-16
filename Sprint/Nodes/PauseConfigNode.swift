//
//  PauseConfigNode.swift
//  Sprint
//
//  Created by Ghaida Atoum on 12/15/24.
//
import Foundation
import SpriteKit

class CloseOptionsButton: SKSpriteNode, VibrateProtocol{}

class PauseConfigNode: SKNode {
    
    var optionsLabel: SKLabelNode
    
    var vibrationLabel: SKLabelNode
    var vibrationToggle: VibrationToggle
    
    var soundLablel: SKLabelNode
    var soundToggle: SoundToggle
    
    var optionsBackground: SKSpriteNode
    var closeButton: CloseOptionsButton
    
    init(size: CGSize) {
        optionsLabel = SKLabelNode(text: "Options")
        optionsLabel.fontColor = .white
        optionsLabel.fontSize = 32
        optionsLabel.fontName = Constants.fontName
        optionsLabel.position = CGPoint(x: size.width/2, y: size.height/1.4)
        optionsLabel.zPosition = 1
        
        closeButton = CloseOptionsButton(imageNamed: Constants.closeButton)
        closeButton.scale(to: CGSize(width: 48, height: 48))
        closeButton.position = CGPoint(x: size.width/1.5, y: optionsLabel.position.y + 50)
        closeButton.name = "closeButton"
        closeButton.zPosition = 1
        
        vibrationLabel = SKLabelNode(text: "Haptics:")
        vibrationLabel.fontColor = .white
        vibrationLabel.fontSize = 16
        vibrationLabel.fontName = Constants.fontName
        vibrationLabel.position = CGPoint(x: size.width/3, y: size.height/2)
        vibrationLabel.zPosition = 1
        
        if (UserConfig.shared.isVibrationEnabled()) {
            vibrationToggle = VibrationToggle(imageNamed: Constants.toggleOnImage)
        } else {
            vibrationToggle = VibrationToggle(imageNamed: Constants.toggleOffImage)
        }
        
        vibrationToggle.position = CGPoint(x: vibrationLabel.position.x , y: vibrationLabel.position.y - 30)
        vibrationToggle.zPosition = 1
        vibrationToggle.scale(to: CGSize(width: 80, height: 40))
        vibrationToggle.name = "vibrationToggle"
        
        
        soundLablel = SKLabelNode(text: "Sound:")
        soundLablel.fontColor = .white
        soundLablel.fontSize = 16
        soundLablel.fontName = Constants.fontName
        soundLablel.position = CGPoint(x: size.width/1.5, y: size.height/2)
        soundLablel.zPosition = 1
        
        if (SoundManager.shared.isSoundOn()) {
            soundToggle = SoundToggle(imageNamed: Constants.toggleOnImage)
        } else {
            soundToggle = SoundToggle(imageNamed: Constants.toggleOffImage)
        }
        soundToggle.position = CGPoint(x: soundLablel.position.x , y: soundLablel.position.y - 30)
        soundToggle.zPosition = 1
        soundToggle.scale(to: CGSize(width: 80, height: 40))
        soundToggle.name = "soundToggle"
        
        
        optionsBackground = SKSpriteNode(imageNamed: Constants.optionsSceneBackground)
        optionsBackground.scale(to: size)
        optionsBackground.zPosition = 0
        optionsBackground.position = CGPoint(x: size.width/2, y: size.height/2)
        super.init()
        
        addChild(optionsLabel)
        addChild(vibrationLabel)
        addChild(vibrationToggle)
        addChild(soundLablel)
        addChild(soundToggle)
        addChild(optionsBackground)
        addChild(closeButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
