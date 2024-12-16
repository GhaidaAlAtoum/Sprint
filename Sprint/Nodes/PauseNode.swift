//
//  InGameMenuNode.swift
//  Sprint
//
//  Created by Ghaida Atoum on 12/15/24.
//

import Foundation
import SpriteKit

class PauseButton: SKSpriteNode, VibrateProtocol{}
class ResumeButton: SKSpriteNode, VibrateProtocol{}
class HomeButton: SKSpriteNode, VibrateProtocol{}
class OptionsButton: SKSpriteNode, VibrateProtocol{}

class PauseNode: SKNode {
    let pauseButton: PauseButton
    let resumeButton: ResumeButton
    let homeButton: HomeButton
    let optionsButton: OptionsButton
    let pauseConfigNode: PauseConfigNode
    
    init(size: CGSize) {
        pauseButton = PauseButton(imageNamed: Constants.pauseButton)
        pauseButton.scale(to: CGSize(width: 48, height: 48))
        pauseButton.position = CGPoint(x: size.width - 70, y: size.height - 70)
        pauseButton.name = "pauseButton"
        pauseButton.zPosition = 1
        
        resumeButton = ResumeButton(imageNamed: Constants.resumeButton)
        resumeButton.scale(to: CGSize(width: 144, height: 144))
        resumeButton.position = CGPoint(x: size.width/2, y: size.height/2)
        resumeButton.name = "resumeButton"
        resumeButton.zPosition = 1
        
        homeButton = HomeButton(imageNamed: Constants.homeButton)
        homeButton.scale(to: CGSize(width: 96, height: 96))
        homeButton.position = CGPoint(x: size.width/2 - 200, y: size.height/2 - 48)
        homeButton.name = "homeButton"
        homeButton.zPosition = 1
        
        optionsButton = OptionsButton(imageNamed: Constants.optionsButton)
        optionsButton.scale(to: CGSize(width: 96, height: 96))
        optionsButton.position = CGPoint(x: size.width/2 + 200, y: size.height/2 - 48)
        optionsButton.name = "configButton"
        optionsButton.zPosition = 1
        
        pauseConfigNode = PauseConfigNode(size: size)
        pauseConfigNode.zPosition = 2
        
        super.init()
        addChild(pauseButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func checkPauseNodePressed(scene: SKScene, touchedNode: SKNode) {
        switch(touchedNode) {
        case is PauseButton:
            animateButtonPressed(button: pauseButton, baseTextureName: Constants.pauseButton)
            pauseButtonPressed(scene: scene)
            break
        case is ResumeButton:
            animateButtonPressed(button: resumeButton, baseTextureName: Constants.resumeButton)
            pauseButtonPressed(scene: scene)
            break
        case is HomeButton:
            homeButtonPressed(scene: scene)
            break
        case is VibrationToggle:
            UserConfig.shared.toggleVibration()
            animateToggle(toggle: pauseConfigNode.vibrationToggle, isOn: UserConfig.shared.isVibrationEnabled())
            break
        case is SoundToggle:
            SoundManager.shared.toggleSound()
            animateToggle(toggle: pauseConfigNode.soundToggle, isOn: SoundManager.shared.isSoundOn())
            SoundManager.shared.playSoundTrack()
            break
        case is OptionsButton:
            optionsButtonPressed()
            break
        case is CloseOptionsButton:
            animateButtonPressed(button: pauseConfigNode.closeButton, baseTextureName: Constants.closeButton)
            self.closeButtonPressed()
            break
        default:
            break
        }
    }
    
    func closeButtonPressed() {
        self.run(waitForAnimation) {
            self.pauseConfigNode.closeButton.texture = SKTexture(imageNamed: Constants.closeButton)
            self.pauseConfigNode.removeFromParent()
        }
    }
    
    func pauseButtonPressed(scene: SKScene) {
        self.pauseButton.run(waitForAnimation) {
            UserConfig.shared.togglePause()
            self.pauseButton.texture = SKTexture(imageNamed: Constants.pauseButton)
            self.resumeButton.texture = SKTexture(imageNamed: Constants.resumeButton)
            if (UserConfig.shared.isPaused()) {
                self.addChild(self.resumeButton)
                self.addChild(self.homeButton)
                self.addChild(self.optionsButton)
            } else {
                self.resumeButton.removeFromParent()
                self.homeButton.removeFromParent()
                self.optionsButton.removeFromParent()
            }
        }
    }
    
    func homeButtonPressed(scene: SKScene) {
        animateButtonPressed(button: homeButton, baseTextureName: Constants.homeButton)
        
        homeButton.run(waitForAnimation) {
            let sequence = SKAction.sequence([
                waitForAnimation, fadeOut
            ])
            
            scene.run(sequence) {
                UserConfig.shared.togglePause()
                SceneTransitioner.shared.transition(scene, toScene: MainMenuScene(size: scene.size))
            }
        }
    }
    
    func optionsButtonPressed() {
        animateButtonPressed(button: optionsButton, baseTextureName: Constants.optionsButton)
        optionsButton.run(waitForAnimation) {
            self.addChild(self.pauseConfigNode)
            self.optionsButton.texture = SKTexture(imageNamed: Constants.optionsButton)
        }
    }

    
}
