//
//  player.swift
//  Sprint
//
//  Created by Ghaida Atoum on 12/14/24.
//

import Foundation
import SpriteKit

class PlayerNode: SKSpriteNode{}

class PlayerModel {
    let node: PlayerNode
    let playerAnimation: SKAction
    let numberOfTexturesIdel = 10
    let movementSpeed: CGFloat = 2.0
    let basePlayerPosision: CGPoint
    let animatePlayerMovementDuration = 0.1
    let wrapAnimationName = "wrapPlayerAnimation"
    
    init(size: CGSize) {
        node = PlayerNode(imageNamed: Constants.playerImageIdleBaseName + "0")
        node.size = CGSize(width: 809/8, height: 1024/8)
        basePlayerPosision = CGPoint(x: size.width/8, y: (size.height/2 - size.height/2.5) + node.size.height)
        node.position = basePlayerPosision
        node.zPosition = 1
        node.name = "player"
        
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.allowsRotation = false
        node.physicsBody?.restitution = 0.0
        node.physicsBody?.friction = 1.0
        node.physicsBody?.categoryBitMask = PhysicsCategory.player
        node.physicsBody?.collisionBitMask = PhysicsCategory.ground
        node.physicsBody?.contactTestBitMask = PhysicsCategory.ground
        
        playerAnimation = SKAction.animate(with: getTextures(baseImageName: Constants.playerImageIdleBaseName , numberOfImages: Constants.playerImageIdleNumberOfImages), timePerFrame: 0.1)
    }
    
    func startPlayerAnimation() {
        if node.action(forKey: "animation") == nil {
            node.run(SKAction.repeatForever(playerAnimation), withKey: "animation")
        }
    }
    
    func stopPlayerAnimation() {
        node.removeAction(forKey: "animation")
    }
    
    func movePlayer(direction: Direction) {
        self.movePlayer(distance: self.movementSpeed, direction: direction)
    }
    
    func movePlayer(distance: CGFloat, direction: Direction) {
        if (allowedToMovePlayer()) {
            node.position.x += (direction.rawValue * distance)
            if (direction == Direction.left) {
                node.xScale = -1.0
            } else {
                node.xScale = 1.0
            }
        }
    }
    
    func allowedToMovePlayer() -> Bool {
        return node.action(forKey: wrapAnimationName) == nil
    }
    
    func wrapPlayer(finalLocation: CGFloat, direction: Direction, screenWidth: CGFloat) {
        node.run(SKAction.sequence([
            SKAction.move(to: CGPoint(x: direction.rawValue * (screenWidth + screenWidth/2), y: node.position.y), duration: animatePlayerMovementDuration),
            SKAction.hide(),
            SKAction.move(to: CGPoint(x: direction.rawValue * (-screenWidth), y: node.position.y), duration: animatePlayerMovementDuration),
            SKAction.wait(forDuration: animatePlayerMovementDuration),
            SKAction.unhide(),
            SKAction.move(to: CGPoint(x: finalLocation, y: node.position.y), duration: animatePlayerMovementDuration)
        ]), withKey: wrapAnimationName)
    }
}
