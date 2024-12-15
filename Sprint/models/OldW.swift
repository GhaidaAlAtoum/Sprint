//
//  Weapon.swift
//  Sprint
//
//  Created by Ghaida Atoum on 12/15/24.
//

import Foundation
import SpriteKit

enum WeaponType {
    case basic
    case second
}

class WeaponNode: SKSpriteNode {}

class OldW {
    let damage: Int
    let node: WeaponNode
    let initialPos: CGPoint
    
    init(damage: Int, size: CGSize, type: WeaponType, position: CGPoint) {
        self.damage = damage
        switch type {
        case .basic:
            self.node = WeaponNode(imageNamed: "axe1")
            break
        default:
            self.node = WeaponNode(imageNamed: "axe4")
            break
        }
        
        node.size = CGSize(width: 88/2, height: 119/2)
        node.position = position
        initialPos = node.position
        node.xScale = -1.0 //TODO: Might not always be needed to flip horizontaly
        node.zRotation = -45
    }
    
    func animateWeaponStd(duration: CGFloat) {
        node.position = initialPos
        node.removeAllActions()
        let wait = SKAction.wait(forDuration: duration)
        let moveDown = SKAction.moveBy(x: 0, y: -2, duration: 0)
        let moveBack = SKAction.moveBy(x: 0, y: 2, duration: 0)
        let sequence = SKAction.sequence([moveDown, wait, moveBack, wait])
        node.run(SKAction.repeatForever(sequence))
    }
    
    func animateWeaponWalking(duration: CGFloat, direction: Direction) {
        node.position = initialPos
        node.removeAllActions()
        let wait = SKAction.wait(forDuration: duration)
        let moveDown = SKAction.moveBy(x: 3, y: -2, duration: 0)
        let moveRightLeft = SKAction.moveBy(x: -3 * direction.rawValue, y: 0, duration: 0)
        let moveBack = SKAction.moveBy(x: 0, y: 2, duration: 0)
        let sequence = SKAction.sequence([moveDown, wait, moveRightLeft, wait, moveBack, wait])
        node.run(SKAction.repeatForever(sequence), withKey: "animateWalking")
    }
    
    func stopWalkingAnimation() {
        node.removeAction(forKey: "animateWalking")
    }
    
    func collideWithFloor() {
        node.zRotation = -45
    }
    
    func jumpAttack() {
        node.removeAllActions()
        let rotationAction = SKAction.rotate(byAngle: -45, duration: 0.1)
        node.run(rotationAction)
    }
}
