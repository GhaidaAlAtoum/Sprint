//
//  MainMenuScene.swift
//  Sprint
//
//  Created by Ghaida Atoum on 12/14/24.
//

import Foundation
import SpriteKit

class MainMenuScene: SKScene {
    let background: Background
    let mainMenuOptionsNode: MainMenuOptionsNode
    
    override init(size: CGSize) {
        // Setup Background
        background = Background(imageNamed: Constants.mainMenuBackgroundImageName)
        background.scale(to: size)
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = -1
        
        // Add Main Menu Options
        mainMenuOptionsNode = MainMenuOptionsNode(size: size)
        
        super.init(size: size)
        
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
//                let internLevelScene = InternLevelScene(size: self.size)
//                levelOneScene.scaleMode = self.scaleMode
//                animateButton(button: playButton, textureName: "Button")
//                playLabel.position.y -= 10
//                transitionToNextScene(scene: levelOneScene)
            default:
                break
            }
        }
    }
    
    func startGame() {
        print("Attempting to start game")
        SceneTransitioner.shared.transition(self, toScene: SceneTransitioner.shared.getNextLevelScene(size: self.size))
    }
}
