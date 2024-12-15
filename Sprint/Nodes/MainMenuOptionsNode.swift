//
//  MainMenuOptionsNode.swift
//  Sprint
//
//  Created by Ghaida Atoum on 12/14/24.
//


import Foundation
import SpriteKit

class StartGameButton: SKSpriteNode{}
class StartGameLabel: SKLabelNode{}

class MainMenuOptionsNode: SKNode {
    let startGameButton: StartGameButton
    let startGameLabel: StartGameLabel
    
    init(size: CGSize) {
        startGameButton = StartGameButton(imageNamed: Constants.baseRedButtonImageName)
        startGameButton.scale(to: CGSize(width: 200, height: 50))
        startGameButton.position = CGPoint(x: size.width/2, y: size.height/2.5)
        startGameButton.zPosition = 0
        startGameButton.name = "playButton"
        
        startGameLabel = StartGameLabel(text: "Start Game")
        startGameLabel.fontSize = 24
        startGameLabel.position = startGameButton.position
        startGameLabel.fontColor = .white
        startGameLabel.horizontalAlignmentMode = .center
        startGameLabel.verticalAlignmentMode = .center
        
        super.init()
        addChild(startGameButton)
        addChild(startGameLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
