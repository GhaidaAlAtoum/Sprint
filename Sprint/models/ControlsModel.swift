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

class JumpLabel: SKLabelNode{}
class JumpButton: SKSpriteNode {}

class AttackLabel: SKLabelNode {}
class AttackButton: SKSpriteNode {}

class ControlsModel {
    let leftArrowButton: LeftArrowButton
    let rightArrowButton: RightArrowButton
    
    let jumpLabel: JumpLabel
    let jumpButton: JumpButton
    
    let attackLabel: AttackLabel
    let attackButton: AttackButton
    
    
    let weaponControlRect: CGRect
    
    init(size: CGSize) {
        let buttonsX = size.width / 9
        let buttonsSize: CGFloat = 80
        let buttonsHeight = size.height / 4 - buttonsSize / 1.5
        
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
        
        jumpButton = JumpButton(imageNamed: Constants.circularControButton)
        jumpButton.scale(to: CGSize(width: buttonsSize, height: buttonsSize))
        jumpButton.position = CGPoint(x:  size.width - buttonsX * 1.1, y: buttonsHeight)
        jumpButton.zPosition = 1
        jumpButton.name = "jumpButton"
        
        jumpLabel = JumpLabel(text: "Jump")
        jumpLabel.fontSize = 20
        jumpLabel.position = jumpButton.position
        jumpLabel.zPosition = 2
        jumpLabel.verticalAlignmentMode = .center
        
        attackButton = AttackButton(imageNamed: Constants.circularControButton)
        attackButton.scale(to: CGSize(width: buttonsSize, height: buttonsSize))
        attackButton.position = CGPoint(x: jumpButton.position.x - buttonsX * 1.1, y: buttonsHeight)
        attackButton.zPosition = 1
        attackButton.name = "attackButton"
        
        attackLabel = AttackLabel(text: "Attack")
        attackLabel.fontSize = 20
        attackLabel.position = attackButton.position
        attackLabel.zPosition = 2
        attackLabel.verticalAlignmentMode = .center
        
        weaponControlRect = CGRect(
            x: rightArrowButton.position.x + buttonsSize,
            y: buttonsHeight,
            width: (attackButton.position.x - attackButton.size.width) - (rightArrowButton.position.x + rightArrowButton.size.width),
            height: buttonsHeight
        )
    }
    
    func getChildren() -> [SKNode] {
        return [
            leftArrowButton,
            rightArrowButton,
            jumpButton,
            attackButton,
            jumpLabel,
            attackLabel
        ]
    }
    
    func getBaseTextureName(_ node: SKNode) -> String? {
        switch(node) {
        case is LeftArrowButton: return Constants.leftArrowImageName
        case is RightArrowButton: return Constants.rightArrowImageName
        case is JumpLabel: return Constants.circularControButton
        case is AttackLabel: return Constants.circularControButton
        case is JumpButton: return Constants.circularControButton
        case is JumpLabel: return Constants.circularControButton
        default: return nil
        }
    }
    
    func getWeaponSelectionBoundingRect() -> CGRect {
        return weaponControlRect
    }
    
    func updateSelectedWeapon(weaponName: String) {
        attackButton.texture = SKTexture(imageNamed: WeaponsManager.getWeaponSelectedForAttack(weaponName: weaponName, level: UserConfig.shared.getCurrentLevel()))
        attackLabel.isHidden = true
    }

}
