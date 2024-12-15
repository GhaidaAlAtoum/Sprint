//
//  WeaponModel.swift
//  Sprint
//
//  Created by Ghaida Atoum on 12/15/24.
//

import Foundation
import SpriteKit


class WeaponModel {
    let name: String
    let damage: Int
    let projectileTexture: String
    
    init(name: String, damage: Int, size: CGSize, position: CGPoint, projectileTexture: String) {
        self.projectileTexture = projectileTexture
        self.damage = damage
        self.name = name
    }
    
    func fireProjectile(playerPosition: CGPoint, scene: SKScene, duration: TimeInterval, direction: Direction) {
        let torpedoNode = SKSpriteNode(imageNamed: self.projectileTexture)
        torpedoNode.position = playerPosition
        torpedoNode.position.x += direction.rawValue * 5
        
        torpedoNode.physicsBody = SKPhysicsBody(circleOfRadius: torpedoNode.size.width / 2)
        torpedoNode.physicsBody?.isDynamic = true
        
        torpedoNode.physicsBody?.categoryBitMask = PhysicsCategory.projictile
        torpedoNode.physicsBody?.collisionBitMask = PhysicsCategory.enemy
        torpedoNode.physicsBody?.contactTestBitMask = PhysicsCategory.enemy
       
        torpedoNode.physicsBody?.usesPreciseCollisionDetection = true
        
        scene.addChild(torpedoNode)
        
        let animationDuration:TimeInterval = duration
        
        var actionArray = [SKAction]()
        
        actionArray.append(SKAction.move(to: CGPoint(x: direction.rawValue * (scene.size.width + 10), y: playerPosition.y), duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        
        torpedoNode.run(SKAction.sequence(actionArray))
    }
}
