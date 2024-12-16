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
    
    let numberOfTexturesIdel = 10
    let movementSpeed: CGFloat = 2.0
    let basePlayerPosision: CGPoint
    let animatePlayerMovementDuration = 0.1
    let wrapAnimationName = "wrapPlayerAnimation"
    
    var isJumping: Bool = false
    var jumpForce: CGFloat = 400.0
    
    let walkingTextures:[SKTexture]
    let walkingDuration: TimeInterval
    let walkingAnimation: SKAction
    
    let idleTextures:[SKTexture]
    let idleDuration: TimeInterval
    let idleAnimation: SKAction
    
    let jumpTextures:[SKTexture]
    let jumpDuration: TimeInterval
    let jumpAnimation: SKAction
    
    let idleAttackTextures:[SKTexture]
    let idleAttackDuration: TimeInterval
    let idleAttackAnimation: SKAction
    
    let runAttackTextures:[SKTexture]
    let runAttackDuration: TimeInterval
    let runAttackAnimation: SKAction
 
    var latestDirection: Direction = .right
    
    var hp: Int = 3
    var damageCD = false
    
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
        node.physicsBody?.collisionBitMask = PhysicsCategory.ground | PhysicsCategory.enemy
        node.physicsBody?.contactTestBitMask = PhysicsCategory.ground | PhysicsCategory.enemy
        
        walkingTextures = getTextures(baseImageName: Constants.playerImageWalkBaseName , numberOfImages: Constants.playerImageWalkNumberOfImages)
        walkingDuration = 1/TimeInterval(walkingTextures.count)
        walkingAnimation = SKAction.animate(with: walkingTextures, timePerFrame: walkingDuration, resize: false, restore: false)
        
        
        idleTextures = getTextures(baseImageName: Constants.playerImageIdleBaseName , numberOfImages: Constants.playerImageIdleNumberOfImages)
        idleDuration = 1/TimeInterval(idleTextures.count)
        idleAnimation = SKAction.animate(with: idleTextures, timePerFrame: idleDuration, resize: false, restore: false)
        
        
        jumpTextures = getTextures(baseImageName: Constants.playerImageJumpBaseName , numberOfImages: Constants.playerImageJumpNumberOfImages)
        jumpDuration = 1/TimeInterval(jumpTextures.count)
        jumpAnimation = SKAction.animate(with: jumpTextures, timePerFrame: jumpDuration, resize: false, restore: false)
       
        
        idleAttackTextures = getTextures(baseImageName: Constants.playerIdleAttackBaseName , numberOfImages: Constants.playerIdleAttackNumberOfImages)
        idleAttackDuration = 1/TimeInterval(idleAttackTextures.count)
        idleAttackAnimation = SKAction.animate(with: idleAttackTextures, timePerFrame: idleAttackDuration, resize: false, restore: false)
        
        
        runAttackTextures = getTextures(baseImageName: Constants.playerRunAttackBaseName , numberOfImages: Constants.playerRunAttackNumberOfImages)
        runAttackDuration = 1/TimeInterval(runAttackTextures.count)
        runAttackAnimation = SKAction.animate(with: runAttackTextures, timePerFrame: runAttackDuration, resize: false, restore: false)
    }
    
    func animateIdle() {
        if (!isJumping) {
            if (!damageCD) {
                if node.action(forKey: "idleAnimation") == nil {
                    node.size = CGSize(width: 809/8, height: 1024/8)
                    node.run(SKAction.repeatForever(idleAnimation), withKey: "idleAnimation")
                }
            }
        }
    }
    
    func startPlayerWalkingAnimation(direction: Direction) {
        if (!isJumping) {
            if (!damageCD) {
                node.removeAction(forKey: "idleAnimation")
                if node.action(forKey: "animateWalking") == nil && node.action(forKey: "runAttackAnimation") == nil {
                    node.run(SKAction.repeatForever(walkingAnimation), withKey: "animateWalking")
                }
            }
        }
    }
    
    func stopPlayerWalkingAnimation() {
        node.removeAction(forKey: "animateWalking")
    }
    
    func movePlayer(direction: Direction) {
        latestDirection = direction
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
    
    func playerJump() {
        node.size = CGSize(width: 809/10, height: 1024/10)
        node.texture = SKTexture(imageNamed: Constants.playerImageJumpBaseName + "0")
        
        node.removeAllActions()
        if isJumping {return}
        isJumping = true
        
        node.run(SKAction.group([
            SKAction.run({
                self.node.physicsBody?.applyImpulse(CGVector(dx: 0, dy: self.jumpForce))
            }),
            jumpAnimation
        ]))
        
        node.size = CGSize(width: 809/8, height: 1024/8)
        node.position.y = basePlayerPosision.y
    }
    
    func collideWithFloor() {
        isJumping = false
    }
    
    func attack(weaponModel: WeaponModel, scene: SKScene, isMoving: Bool) {
        var animationToRun = idleAttackAnimation
        var duration = idleAttackDuration
        var count = idleAttackTextures.count
        var firstTexture = idleAttackTextures[0]
        var animationName = "idleAttackAnimation"
        if (isMoving) {
            animationToRun = runAttackAnimation
            duration = runAttackDuration
            count = runAttackTextures.count
            animationName = "runAttackAnimation"
            firstTexture = runAttackTextures[0]
        }
        
        node.size = CGSize(width: 809/10, height: 1024/10)
        node.texture = firstTexture
        
        node.removeAllActions()
        node.run(SKAction.group([
            SKAction.run {
                weaponModel.fireProjectile(playerPosition: self.node.position, scene: scene, duration: duration * Double(count), direction: self.latestDirection)
            },
            animationToRun
        ]), withKey: animationName)
        
        node.size = CGSize(width: 809/8, height: 1024/8)
    }
    
//    func takeDamage(direction: CGFloat, damage: Int, enemyWidth: CGFloat) {
//        if (!damageCD) {
//            hp -= damage
//            node.removeAllActions()
//            node.size = CGSize(width: 809/10, height: 1024/10)
//            node.physicsBody?.velocity = CGVector.zero
//            if (isJumping) {
//                node.physicsBody?.applyImpulse(CGVector(dx: (enemyWidth + 50) * direction , dy: jumpForce))
//            } else {
//                node.physicsBody?.applyImpulse(CGVector(dx: (enemyWidth + 40) * direction , dy: jumpForce))
//            }
//            
//            damageCD = true
//            let waitAction = SKAction.wait(forDuration: 1)
//            let runAction = SKAction.run {
//                self.damageCD = false
//            }
//            node.run(SKAction.sequence([
//                waitAction,
//                SKAction.run {
//                    self.animateIdle()
//                }
//            ]))
//            
//            let sequence = SKAction.sequence([waitAction, runAction])
//            node.run(sequence, withKey: "damage")
//        }
//    }
    
    func takeDamage(damage: Int) {
        return
    }
}
