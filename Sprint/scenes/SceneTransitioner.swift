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
    
    func transition(_ fromScene: SKScene, toScene: SKScene, transition: SKTransition? = nil) {
        toScene.scaleMode = fromScene.scaleMode
        fromScene.run(waitForAnimation) {
            if (transition == nil) {
                fromScene.view?.presentScene(toScene)
            } else {
                fromScene.view?.presentScene(toScene, transition: transition!)
            }
        }
    }
    
    func getNextLevelScene(size: CGSize) -> SKScene{
        switch(UserConfig.shared.getCurrentLevel()) {
        case 0:
            return FirstLevelScene(size: size)
        case 1:
            return SecondLevelScene(size: size)
        case 2:
            return ThirdLevelScene(size: size)
        case 3:
            return BossLevelScene(size: size)
        case 4:
            UserConfig.shared.updateCurrentLevel(0)
            return MainMenuScene(size: size)
        default:
            return MainMenuScene(size: size)
        }
    }
}
