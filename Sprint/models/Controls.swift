//
//  Controls.swift
//  Sprint
//
//  Created by Ghaida Atoum on 12/14/24.
//

import Foundation
import SpriteKit


class LeftArrowButton: SKSpriteNode {}
class RightArrowButton: SKSpriteNode {}

class Controls {
    let leftArrowButton: LeftArrowButton
    let rightArrowButton: RightArrowButton
    
    init(size: CGSize) {
        let buttonsX = size.width / 9
        let buttonsSize: CGFloat = 80
        let buttonsHeight = size.height / 4 - buttonsSize / 1.5
        
        print(buttonsHeight)
        
        leftArrowButton = LeftArrowButton(imageNamed: Constants.leftArrowImageName)
        leftArrowButton.scale(to: CGSize(width: buttonsSize, height: buttonsSize))
        leftArrowButton.position = CGPoint(x: buttonsX, y: buttonsHeight)
        leftArrowButton.zPosition = 1
        leftArrowButton.name = "leftButton"
        
        rightArrowButton = RightArrowButton(imageNamed: Constants.rightArrowImageName)
        rightArrowButton.scale(to: CGSize(width: buttonsSize, height: buttonsSize))
        rightArrowButton.position = CGPoint(x: buttonsX + buttonsSize * 1.5, y: buttonsHeight)
        rightArrowButton.zPosition = 1
        rightArrowButton.name = "rightButton"
    }
    
    func getChildren() -> [SKNode] {
        return [
            leftArrowButton,
            rightArrowButton
        ]
    }
}
