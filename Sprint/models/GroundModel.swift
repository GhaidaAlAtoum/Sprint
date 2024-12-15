//
//  Untitled.swift
//  Sprint
//
//  Created by Ghaida Atoum on 12/14/24.
//
import Foundation
import SpriteKit

class GroundModel {
    let node: SKSpriteNode
    
    init(size: CGSize, playerPosition: CGPoint, playerSize: CGSize) {
        node = SKSpriteNode(color: .clear, size: CGSize(width: size.width, height: 10))
        node.position = CGPoint(x: size.width/2, y: playerPosition.y - playerSize.height/2)
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.isDynamic = false
        node.physicsBody?.categoryBitMask = PhysicsCategory.ground
        node.physicsBody?.collisionBitMask = PhysicsCategory.player
        node.physicsBody?.contactTestBitMask = PhysicsCategory.player
    }
}
