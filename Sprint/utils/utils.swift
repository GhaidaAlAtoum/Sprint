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


func getTextures(baseImageName: String, numberOfImages: Int) -> [SKTexture] {
    var textures:[SKTexture] = []
    for i in 0..<numberOfImages{
        textures.append(SKTexture(imageNamed: baseImageName + "\(i)"))
    }
    textures.append(textures[2])
    textures.append(textures[1])
    return textures
}
