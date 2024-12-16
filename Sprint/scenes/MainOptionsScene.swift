//
//  MainOptionsScene.swift
//  Sprint
//
//  Created by Ghaida Atoum on 12/15/24.
//

import SpriteKit
import Foundation

class BackButton: SKSpriteNode, VibrateProtocol{}
class SoundToggle: SKSpriteNode, VibrateProtocol{}
class VibrationToggle: SKSpriteNode, VibrateProtocol{}

class MainOptionsScene: SKScene {
    let background: Background
    
    let titleLabel: SKLabelNode
    
    let backButton: BackButton
    
    let soundLabel: SKLabelNode
    let soundToggle: SoundToggle
    
    let vibrationLabel: SKLabelNode
    let vibrationToggle: VibrationToggle
    let fontColor: UIColor = .black
    
    override init(size: CGSize) {
        // Setup Background
        background = Background(imageNamed: Constants.optionsSceneBackground)
        background.scale(to: size)
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = -1
        
        // Title
        titleLabel = SKLabelNode(text: "Options")
        titleLabel.fontSize = 100
        titleLabel.fontColor = fontColor
        titleLabel.position = CGPoint(x: size.width/2, y: size.height/1.3)
        titleLabel.fontName =  Constants.fontName
        
        // Back Button
        backButton = BackButton(imageNamed: Constants.backButtonName)
        backButton.scale(to: CGSize(width: size.width / 15, height: size.width / 15))
        backButton.position = CGPoint(x: 100, y: size.height - 100)
        backButton.name = "backButton"
        
        // Sound Label
        soundLabel = SKLabelNode(text: "Sound")
        soundLabel.fontSize = 50
        soundLabel.fontColor = fontColor
        soundLabel.fontName = Constants.fontName
        soundLabel.position = CGPoint(x: titleLabel.position.x, y: titleLabel.position.y - 80)
        
        // Sound Toggle
        if (SoundManager.shared.isSoundOn()) {
            soundToggle = SoundToggle(imageNamed: Constants.toggleOnImage)
        } else {
            soundToggle = SoundToggle(imageNamed: Constants.toggleOffImage)
        }
        
        soundToggle.scale(to: CGSize(width: size.width / 10, height: size.width / 15))
        soundToggle.position = CGPoint(x: soundLabel.position.x, y: soundLabel.position.y - 50)
        soundToggle.zPosition = 0
        soundToggle.name = "soundToggle"
        
        // vibration label
        vibrationLabel = SKLabelNode(text: "Vibration")
        vibrationLabel.fontColor = fontColor
        vibrationLabel.zPosition = 0
        vibrationLabel.fontSize = 50
        vibrationLabel.fontName = Constants.fontName
        vibrationLabel.position = CGPoint(x: soundToggle.position.x, y: soundToggle.position.y - 80)
        
        // vibration toggle
        if (UserConfig.shared.isVibrationEnabled()) {
            vibrationToggle = VibrationToggle(imageNamed:  Constants.toggleOnImage)
        } else {
            vibrationToggle  = VibrationToggle(imageNamed: Constants.toggleOffImage)
        }
        
        vibrationToggle.scale(to: CGSize(width: size.width / 10, height: size.width / 15))
        vibrationToggle.position = CGPoint(x: vibrationLabel.position.x, y: vibrationLabel.position.y - 50)
        vibrationToggle.name = "vibrationToggle"
        
        super.init(size: size)
        addChild(background)
        addChild(titleLabel)
        addChild(backButton)
        addChild(soundLabel)
        addChild(soundToggle)
        addChild(vibrationLabel)
        addChild(vibrationToggle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            if(shouldVibrate(node: touchedNode as? VibrateProtocol)) {
                vibrate(with: .light)
            }
            
            switch touchedNode {
            case is BackButton:
                animateButtonPressed(button: backButton, baseTextureName: Constants.backButtonName)
                SceneTransitioner.shared.transition(self, toScene: MainMenuScene(size: size))
            case is SoundToggle:
                SoundManager.shared.toggleSound()
                animateToggle(toggle: soundToggle, isOn: SoundManager.shared.isSoundOn())
                SoundManager.shared.playSoundTrack()
                break
            case is VibrationToggle:
                UserConfig.shared.toggleVibration()
                animateToggle(toggle: vibrationToggle, isOn: UserConfig.shared.isVibrationEnabled())
            default:
                break
            }
        }
    }
}
