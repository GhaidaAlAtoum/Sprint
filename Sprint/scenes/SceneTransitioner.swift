//
//  SceneTransitioner.swift
//  Sprint
//
//  Created by Ghaida Atoum on 12/14/24.
//
import Foundation
import SpriteKit

class SceneTransitioner {
    static let shared:SceneTransitioner = SceneTransitioner()
    
    func transition(_ fromScene: SKScene, toScene: SKScene) {
        toScene.scaleMode = fromScene.scaleMode
        fromScene.run(waitForAnimation) {
            fromScene.view?.presentScene(toScene)
        }
    }
    
    func getNextLevelScene(size: CGSize) -> SKScene{
        switch(UserConfig.shared.getCurrentLevel()) {
        case 1:
            print("Load Level 1")
            return InternLevelScene(size: size)
        case 2:
            print("Load Level 2")
            break
        case 3:
            print("Load Level 3")
            break
        case 4:
            print("Load Level 4")
            break
        default:
            return UnknownScene(size: size)
        }
        return UnknownScene(size: size)
    }
}
