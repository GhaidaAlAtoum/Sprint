//
//  GameOverScene.swift
//  Sprint
//
//  Created by Ghaida Atoum on 12/16/24.
//

import Foundation
import SpriteKit

class LevelLostScene: SKScene {
    let playerModel: PlayerModel
    
    let topBackground1: Background
    let topBackground2: Background
    let bottomBackground: Background
    let groundModel: GroundModel
    
    let stessHighNode: SKSpriteNode
    
    override init(size: CGSize) {
        SoundManager.shared.stopSounds()
        topBackground1 = Background(imageNamed: Constants.internLevelBackgroundImageName)
        topBackground1.scale(to: CGSize(width: size.width, height: size.height/1.25))
        topBackground1.anchorPoint = CGPointZero
        topBackground1.position = CGPoint(x: 0, y: size.height/5)
        topBackground1.zPosition = -1
        
        topBackground2 = Background(imageNamed: Constants.internLevelBackgroundImageName)
        topBackground2.anchorPoint = CGPointZero
        topBackground2.scale(to: CGSize(width: size.width, height: size.height/1.25))
        topBackground2.position = CGPoint(x: topBackground1.size.width-1, y:  size.height/5)
        topBackground2.zPosition = -1
        
        bottomBackground = Background(imageNamed: Constants.controlBackground)
        bottomBackground.scale(to: CGSize(width: size.width, height: size.height/4))
        bottomBackground.position = CGPoint(x: size.width/2, y: size.height/2 - size.height/2.65)
        bottomBackground.zPosition = -1
        
        stessHighNode = SKSpriteNode(imageNamed: Constants.stressHigh)
        stessHighNode.zPosition = 0
        stessHighNode.position = CGPoint(x: size.width/2, y: size.height/2)
        
        playerModel = PlayerModel(size: size)
        groundModel = GroundModel(size: size, playerPosition: playerModel.node.position, playerSize: playerModel.node.size)
        
        super.init(size: size)
    }
    
    override func didMove(to view: SKView) {
        addChild(topBackground1)
        addChild(topBackground2)
        addChild(bottomBackground)
        addChild(stessHighNode)
        addChild(playerModel.node)
        addChild(groundModel.node)
        
        
        playerModel.animateLost()
        run(SKAction.playSoundFileNamed("wahwah.mp3", waitForCompletion: false))
        
        run(SKAction.wait(forDuration: 5)) {
            SceneTransitioner.shared.transition(self, toScene: MainMenuScene(size: self.size))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
