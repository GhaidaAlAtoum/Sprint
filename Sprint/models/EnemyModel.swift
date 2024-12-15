//
//  EnemyModel.swift
//  Sprint
//
//  Created by Ghaida Atoum on 12/15/24.
//

import Foundation
import SpriteKit

class EnemyModel {
    var node: SKSpriteNode
    var hp: Int
    var damage: Int
    var textures: [SKTexture]
    var speed: CGFloat
    var movCD: Bool = false
    var dmgCD: Bool = false
    
    init(node: SKSpriteNode, hp: Int, damage: Int, textures: [SKTexture], speed: CGFloat) {
        self.node = node
        self.hp = hp
        self.damage = damage
        self.textures = textures
        self.speed = speed
    }
    
    func moveEnemy(direction: CGFloat) {
        fatalError("moveEnemy(direction:) has not been implemented")
    }
    
    func takeDamage(direction: CGFloat) -> Bool{
        fatalError("takeDamage(direction:) has not been implemented")
    }
    
    func animateEnemyWalk() {
        fatalError("animateWalk() has not been implemented")
    }
}
