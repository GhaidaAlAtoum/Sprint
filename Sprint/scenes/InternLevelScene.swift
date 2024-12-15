//
//  InternLevelScene.swift
//  Sprint
//
//  Created by Ghaida Atoum on 12/14/24.
//

import Foundation
import SpriteKit

class InternLevelScene: SKScene {
    let playerModel: PlayerModel
    let groundModel: GroundModel
    let controlsModel: ControlsModel
    
    let topBackground1: Background
    let topBackground2: Background
    let bottomBackground: Background
    
    var activeTouches: [UITouch: SKSpriteNode] = [:]
    var playerPlayableRect: CGRect = .zero
    
    let cameraNode: SKCameraNode
    
    let bufferFromSafeAreaToTriggerWrap = 50.0
    let backgroundSpeedMultiplier = 3.0
    
    override init(size: CGSize) {
        topBackground1 = Background(imageNamed: Constants.internLevelBackgroundImageName)
        topBackground1.scale(to: CGSize(width: size.width, height: size.height/1.25))
        topBackground1.anchorPoint = CGPointZero
        topBackground1.position = CGPoint(x: 0, y: size.height/5)
        topBackground1.zPosition = -1
        
        topBackground2 = Background(imageNamed: Constants.internLevelBackgroundImageName)
        topBackground2.anchorPoint = CGPointZero
        topBackground2.scale(to: CGSize(width: size.width, height: size.height/1.25))
        topBackground2.position = CGPoint(x: topBackground1.size.width-1, y:  size.height/5)
        topBackground2.zPosition = -1
        
        bottomBackground = Background(imageNamed: Constants.controlBackground)
        bottomBackground.scale(to: CGSize(width: size.width, height: size.height/4))
        bottomBackground.position = CGPoint(x: size.width/2, y: size.height/2 - size.height/2.65)
        bottomBackground.zPosition = -1
        
        playerModel = PlayerModel(size: size)
        groundModel = GroundModel(size: size, playerPosition: playerModel.node.position, playerSize: playerModel.node.size)
        controlsModel = ControlsModel(size: size)
        
        cameraNode = SKCameraNode()
        cameraNode.position = CGPoint(x: size.width/2, y: size.height/2)
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        // Call here so the safeAreaInsets are set
        playerPlayableRect = determinePlayerPlayableArea()
        addChild(topBackground1)
        addChild(topBackground2)
        addChild(bottomBackground)
        addChild(playerModel.node)
        addChild(groundModel.node)
        addChild(cameraNode)
        for child in controlsModel.getChildren() {
            addChild(child)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchednode = atPoint(location)
            switch touchednode {
            case is LeftArrowButton:
                leftButtonPressed(touch: touch)
                break
            case is RightArrowButton:
                rightButtonPressed(touch: touch)
                break
            default:
                break
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if let button = activeTouches[touch] {
                if !button.contains(location) {
                    deactivate(button: button, textureName: controlsModel.getBaseTextureName(button)!)
                    playerModel.stopPlayerAnimation()
                    activeTouches[touch] = nil
                    
                    let touchedNode = atPoint(location)
                    switch touchedNode {
                    case is LeftArrowButton:
                        leftButtonPressed(touch: touch)
                        break
                    case is RightArrowButton:
                        rightButtonPressed(touch: touch)
                        break
                    default:
                        break
                    }
                }
            } else {
                let touchedNode = atPoint(location)
                switch touchedNode {
                case is LeftArrowButton:
                    leftButtonPressed(touch: touch)
                    break
                case is RightArrowButton:
                    rightButtonPressed(touch: touch)
                    break
                default:
                    break
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if let button = activeTouches[touch] {
                deactivate(button: button, textureName: controlsModel.getBaseTextureName(button)!)
                activeTouches[touch] = nil
                playerModel.stopPlayerAnimation()
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if let button = activeTouches[touch] {
                deactivate(button: button, textureName: controlsModel.getBaseTextureName(button)!)
                activeTouches[touch] = nil
                playerModel.stopPlayerAnimation()
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        movePlayerAndBackground()
    }
    
    func leftButtonPressed(touch: UITouch) {
        activeTouches[touch] = controlsModel.leftArrowButton
        animateButton(button: controlsModel.leftArrowButton, textureName: Constants.leftArrowImageName + Constants.indicatePressed)
    }
    
    func rightButtonPressed(touch: UITouch) {
        activeTouches[touch] = controlsModel.rightArrowButton
        animateButton(button: controlsModel.rightArrowButton, textureName:Constants.rightArrowImageName + Constants.indicatePressed)
    }
    
    func movePlayerAndBackground(){
        // Moving Player Left -> Background Moves to the right
        if (playerModel.allowedToMovePlayer()) {
            if (activeTouches.values.contains(controlsModel.leftArrowButton)) {
                moveBackground(direction: .right)
                playerModel.movePlayer(direction: .left)
                playerModel.startPlayerAnimation()
                if playerModel.node.position.x < CGRectGetMinX(playerPlayableRect) + bufferFromSafeAreaToTriggerWrap {
                    // 1. Move Outside the screen but keep on the left side
                    // 2. Hide
                    // 3. Move to the end of the new screen
                    // 4. Unhide
                    // 5. Move to within the player playable rect
                    playerModel.wrapPlayer(finalLocation: CGRectGetMaxX(playerPlayableRect) - bufferFromSafeAreaToTriggerWrap, direction: .left, screenWidth: size.width)
                    moveBackground(direction: .right)
                }
            }
            
            if (activeTouches.values.contains(controlsModel.rightArrowButton)) {
                moveBackground(direction: .left)
                playerModel.movePlayer(direction: .right)
                playerModel.startPlayerAnimation()
                if playerModel.node.position.x >= CGRectGetMaxX(playerPlayableRect) - bufferFromSafeAreaToTriggerWrap {
                    // 1. Move Outside the screen but keep on the right side
                    // 2. Hide
                    // 3. Move to the begining of the new screen
                    // 4. Unhide
                    // 5. Move to within the player playable rect
                    
                    playerModel.wrapPlayer(finalLocation: CGRectGetMinX(playerPlayableRect) + bufferFromSafeAreaToTriggerWrap, direction: .right, screenWidth: size.width)
                    moveBackground(direction: .left)
                }
            }
        }
        
        cameraNode.position.x = playerModel.node.position.x
    }
    
    func moveBackground(direction: Direction) {
        let distance = playerModel.movementSpeed * backgroundSpeedMultiplier
        topBackground1.position = CGPoint(x: topBackground1.position.x + (direction.rawValue * distance), y: topBackground1.position.y)
        topBackground2.position = CGPoint(x: topBackground2.position.x + (direction.rawValue * distance), y: topBackground2.position.y)
        if (direction == Direction.left) {
            if (topBackground1.position.x < -topBackground1.size.width) {
                topBackground1.position = CGPointMake(topBackground2.position.x + topBackground2.size.width, topBackground1.position.y)
            }
            
            if (topBackground2.position.x < -topBackground2.size.width) {
                topBackground2.position = CGPointMake(topBackground1.position.x + topBackground1.size.width, topBackground2.position.y)
            }
        } else {
            if (topBackground1.position.x > topBackground1.size.width) {
                topBackground1.position = CGPointMake(topBackground2.position.x - topBackground2.size.width, topBackground1.position.y)
            }
            
            if (topBackground2.position.x > topBackground2.size.width) {
                topBackground2.position = CGPointMake(topBackground1.position.x - topBackground1.size.width, topBackground2.position.y)
            }
        }
    }
    
    private func determinePlayerPlayableArea(rightMarginMultiplier: CGFloat = 2.0, leftMargingMultiplier: CGFloat = 2.75) -> CGRect{
        let maxAspectRatio:CGFloat = 16.0 / 9.0
        let playableHeight = size.width / maxAspectRatio
        return CGRect(
            x: (self.view?.safeAreaInsets.left ?? 0.0) * rightMarginMultiplier,
            y: playerModel.node.position.y,
            width: size.width - (self.view?.safeAreaInsets.right ?? 0.0) * leftMargingMultiplier,
            height: playableHeight)
    }
    
    private func debugDrawPlayableArea() {
        let shape = SKShapeNode()
        let path = CGMutablePath()
        path.addRect(playerPlayableRect)
        shape.path = path
        shape.strokeColor = SKColor.red
        shape.lineWidth = 20.0
        
        addChild(shape)
    }
}


