//
//  MainMenuScene.swift
//  Sprint
//
//  Created by Ghaida Atoum on 12/14/24.
//

import Foundation
import SpriteKit

class SoundButton: SKSpriteNode{}

class MainMenuScene: SKScene {
    let background: Background
    let mainMenuOptionsNode: MainMenuNode
    
    override init(size: CGSize) {
        // Setup Background
        background = Background(imageNamed: Constants.mainMenuBackgroundImageName)
        background.scale(to: size)
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = -1
        
        // Add Main Menu Options
        mainMenuOptionsNode = MainMenuNode(size: size)

        super.init(size: size)
        SoundManager.shared.stopSounds()
        SoundManager.shared.playSoundTrack()
        
        addChild(background)
        addChild(mainMenuOptionsNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            
            switch touchedNode {
            case is StartGameButton:
                startGame()
                break
            case is StartGameLabel:
                startGame()
                break
            case is MainMenuOptionsButton:
                openMainOptionsScene()
                break
            case is SoundButton:
                SoundManager.shared.toggleSound()
                animateSoundButton(button: mainMenuOptionsNode.soundButton, isOn: SoundManager.shared.isSoundOn())
                SoundManager.shared.playSoundTrack()
                break
            default:
                break
            }
        }
    }
    
    func startGame() {
        animateButtonPressed(button: mainMenuOptionsNode.startGameButton, baseTextureName: Constants.startGameBaseButton)
        SceneTransitioner.shared.transition(self, toScene: SceneTransitioner.shared.getNextLevelScene(size: self.size))
    }
    
    func openMainOptionsScene() {
        animateButtonPressed(button: mainMenuOptionsNode.optionsButton, baseTextureName: Constants.mainMenuOptionsButtonName)
        SceneTransitioner.shared.transition(self, toScene: MainOptionsScene(size: size))
    }
}
