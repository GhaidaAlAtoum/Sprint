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

class Weapon {
    let damage: Int
    let node: WeaponNode
    
    init(damage: Int, size: CGSize, type: WeaponType) {
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
    }
}
