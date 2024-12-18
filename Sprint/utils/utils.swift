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

func getLevelTopBackgroundName(level: Int) -> String {
    print("level\(level)_background_top")
   return "level\(level)_background_top"
}

func getLevelDuration(level: Int) -> Int {
    switch level {
    case 0 : return 40
    case 1 : return 40
    case 2 : return 40
    case 3 : return 40
    default: return 0
    }
}

func getLevelName(level: Int) -> String {
    switch level {
    case 0 : return "Entry"
    case 1 : return "Senior"
    case 2 : return "Staff"
    case 3 : return "Architect"
    default: return ""
    }
}

func animateButtonPressed(button: SKSpriteNode,  baseTextureName: String) {
    button.texture = SKTexture(imageNamed: baseTextureName + Constants.indicatePressed)
}

func animateToggle(toggle: SKSpriteNode, isOn: Bool) {
    toggle.texture = SKTexture(imageNamed: Constants.toggleTransitionImage)
    toggle.run(waitForAnimation) {
        if(isOn) {
            toggle.texture = SKTexture(imageNamed: Constants.toggleOnImage)
        } else {
            toggle.texture = SKTexture(imageNamed: Constants.toggleOffImage)
        }
    }
}

func animateSoundButton(button: SKSpriteNode, isOn: Bool) {
    button.texture = SKTexture(imageNamed: Constants.soundButtonPressedImage)
    button.run(waitForAnimation) {
        if(isOn) {
            button.texture = SKTexture(imageNamed: Constants.soundButtonOnImage)
        } else {
            button.texture = SKTexture(imageNamed: Constants.soundButtonOffImage)
        }
    }
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


protocol VibrateProtocol: AnyObject{
    
}

func shouldVibrate<T>(node: T?) -> Bool {
    if (node == nil) {
        return false
    }
    return true
}
