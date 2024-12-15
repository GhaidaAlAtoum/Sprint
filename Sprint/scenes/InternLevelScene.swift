//
//  InternLevelScene.swift
//  Sprint
//
//  Created by Ghaida Atoum on 12/14/24.
//

import Foundation
import SpriteKit

class InternLevelScene: SKScene {
    let background: Background
    let player: PlayerModel
    let ground: Ground
    let controls: Controls
    
    override init(size: CGSize) {
        // Setup Background
        background = Background(imageNamed: Constants.internLevelBackgroundImageName)
        background.scale(to: size)
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = -1
        
        player = PlayerModel(size: size)
        ground = Ground(size: size, playerPosition: player.node.position, playerSize: player.node.size)
        controls = Controls(size: size)
        
        super.init(size: size)
        addChild(background)
        addChild(player.node)
        addChild(ground.node)
        for child in controls.getChildren() {
            addChild(child)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
