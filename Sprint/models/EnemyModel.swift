//
//  EnemyModel.swift
//  Sprint
//
//  Created by Ghaida Atoum on 12/15/24.
//

import Foundation
import SpriteKit

class EnemyNode: SKSpriteNode{}

class EnemyModel {
    var node: EnemyNode
        
    init(size: CGSize, node: EnemyNode) {
        self.node = node
        
        node.size = size
        //TODO look into making it around the shape
        self.node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        self.node.physicsBody?.isDynamic = true
        self.node.physicsBody?.allowsRotation = false
        self.node.physicsBody?.friction = 1
        self.node.physicsBody?.restitution = 0
        self.node.physicsBody?.categoryBitMask = PhysicsCategory.enemy
        self.node.physicsBody?.collisionBitMask = PhysicsCategory.ground | PhysicsCategory.player | PhysicsCategory.projictile
        self.node.physicsBody?.contactTestBitMask = PhysicsCategory.ground | PhysicsCategory.player | PhysicsCategory.projictile
    }
    
    static func animateTakingDamage(node: EnemyNode) {
        if node.action(forKey: SceneActions.enemy_taking_damage) == nil {
            let blinkTimes = 10.0
            let duration = 3.0
            let blinkAction = SKAction.customAction(withDuration: duration, actionBlock: { node, elapsedTime in
                let slice = duration / blinkTimes
                let remainder = Double(elapsedTime) % slice
                node.isHidden = remainder > slice / 2
            })
            
            let notDynamic = SKAction.run {
                node.physicsBody?.isDynamic = false
                node.physicsBody?.categoryBitMask = PhysicsCategory.none
            }
            
            let removeFromParent = SKAction.run({node.removeFromParent()})
            
            node.run(SKAction.group([SKAction.sequence([notDynamic, blinkAction, removeFromParent]),  SKAction.playSoundFileNamed("hitEnemy.wav", waitForCompletion: false)]),withKey: SceneActions.enemy_taking_damage)
        }
    }

}
