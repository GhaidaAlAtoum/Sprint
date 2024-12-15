//
//  NewToolsEnemy.swift
//  Sprint
//
//  Created by Ghaida Atoum on 12/15/24.
//

import Foundation
import SpriteKit

class NewToolsEnemy: EnemyModel {
    init(hp: Int, damage: Int, speed: CGFloat) {
//        let textures = [
//            SKTexture(imageNamed: "enemyWalk0"),
//            SKTexture(imageNamed: "enemyWalk0"),
//            SKTexture(imageNamed: "enemyWalk0"),
//        ]
        
        super.init(
            node: SKSpriteNode(imageNamed: "new_tool_enemy"), hp: hp, damage: damage, textures: [], speed: speed)
        
        node.size = CGSize(width: 1024/8, height: 832/8)
//        animateEnemyWalk()
        //TODO look into making it around the shape
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.isDynamic = true
        node.physicsBody?.allowsRotation = false
        node.physicsBody?.friction = 1
        node.physicsBody?.restitution = 0
//        node.physicsBody?.categoryBitMask = PhysicsCategory.enemy
//        node.physicsBody?.collisionBitMask = PhysicsCategory.ground | PhysicsCategory.player | PhysicsCategory.projictile
//        node.physicsBody?.contactTestBitMask = PhysicsCategory.ground | PhysicsCategory.player | PhysicsCategory.projictile
        
    }
    
    override func moveEnemy(direction: CGFloat) {
        if(!movCD) {
            node.xScale = CGFloat(direction)
            node.physicsBody?.velocity = CGVector.zero
            node.physicsBody?.applyImpulse(CGVector(dx: speed * 1.5 * direction, dy: 35))
            movCD = true
            node.run(SKAction.wait(forDuration: 1)) {
                self.movCD = false
            }
        }
    }
    
    override func takeDamage(direction: CGFloat) -> Bool {
        if (!dmgCD) {
            dmgCD = true
            //TODO Change texture to damage Texture
//            node.texture = SKTexture(imageNamed: "enemydamage")
            node.removeAllActions()
            node.physicsBody?.velocity = CGVector.zero
            node.physicsBody?.applyImpulse(CGVector(dx: speed * direction, dy: 35))
            hp -= 1
            if (hp <= 0) {
                node.run(SKAction.wait(forDuration: 1)) {
                    self.node.removeFromParent()
                }
                return true
            }
        }
        return false
    }
    
    override func animateEnemyWalk() {
        node.run(SKAction.repeatForever(SKAction.animate(with: textures, timePerFrame: 1/TimeInterval(textures.count), resize: false, restore: false)))
    }
}
