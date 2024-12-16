//
//  utils.swift
//  Sprint
//
//  Created by Ghaida Atoum on 12/14/24.
//

import Foundation
import SpriteKit
import AVFoundation

let waitForAnimation = SKAction.wait(forDuration: 0.2)
let fadeOut = SKAction.fadeOut(withDuration: 0.4)

class Background: SKSpriteNode {}

enum Direction:CGFloat {
    case left = -1.0
    case right = 1.0
}

func getTextures(baseImageName: String, numberOfImages: Int) -> [SKTexture] {
    var textures:[SKTexture] = []
    for i in 0..<numberOfImages{
        textures.append(SKTexture(imageNamed: baseImageName + "\(i)"))
    }
    textures.append(textures[2])
    textures.append(textures[1])
    return textures
}


func animateButtonPressed(button: SKSpriteNode,  baseTextureName: String) {
    button.texture = SKTexture(imageNamed: baseTextureName + Constants.indicatePressed)
}

func deactivate(button: SKSpriteNode, baseTextureName: String) {
    button.texture = SKTexture(imageNamed: baseTextureName)
}

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func += (left: inout CGPoint, right: CGPoint) {
    left = left + right
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func -= (left: inout CGPoint, right: CGPoint) {
    left = left - right
}

func * (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x * right.x, y: left.y * right.y)
}

func *= (left: inout CGPoint, right: CGPoint) {
    left = left * right
}

func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func *= (point: inout CGPoint, scalar: CGFloat) {
    point = point * scalar
}

func / (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x / right.x, y: left.y / right.y)
}

func /= (left: inout CGPoint, right: CGPoint) {
    left = left / right
}

func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

func /= (point: inout CGPoint, scalar: CGFloat) {
    point = point / scalar
}

extension CGFloat {
    static func %(left: CGFloat, right: CGFloat) -> CGFloat {
        return left.truncatingRemainder(dividingBy: right)
    }
    
    func sign() -> CGFloat {
        return self >= 0.0 ? 1.0 : -1.0
    }
    
    static func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UInt32.max))
        
    }
    
    static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        assert(min < max)
        return CGFloat.random() * (max - min) + min
    }
}
