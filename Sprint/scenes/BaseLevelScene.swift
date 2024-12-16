//
//  BaseLevelScene.swift
//  Sprint
//
//  Created by Ghaida Atoum on 12/15/24.
//


import Foundation
import SpriteKit

struct SceneActions {
    static let spawn_enemy_action:String = "spawn_enemy_action"
    static let move_enemy:String = "move_enemy"
    static let gamer_timer:String = "gamer_timer"
    static let enemy_taking_damage:String = "enemy_taking_damage"
    static let player_taking_damage:String = "player_taking_damage"
    static let player_idle_animation:String = "idleAnimation"
    static let player_walking_animation:String = "animateWalking"
    static let player_run_attack_animation:String = "runAttackAnimation"
    static let player_idle_attack_animation:String = "runAttackAnimation"
    static let player_lost_animation:String = "lostanimation"
    static let player_won_animation:String = "wonanimation"
}

class BaseLevelScene: SKScene {
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
    
    var pressingJumpAttack: Bool = false
    
    let pauseNode: PauseNode
    
    var gameTimeSeconds: Int = 100 {
        didSet {
            timerLabel.text = "\(gameTimeSeconds)"
        }
    }
    
    let maxStessAllowed:Int
    
    var currentStressMeter: Int = 0 {
        didSet {
            stressLabel.text = "Stress: \(currentStressMeter)/\(maxStessAllowed)"
            if (currentStressMeter >= maxStessAllowed) {
                gameOver()
            }
        }
    }
    
    var damageCaused: Int = 1
    var enemies:[EnemyNode] = []
    
    let timerLabel: SKLabelNode
    
    let timerBackground: SKSpriteNode
    
    let stressLabel: SKLabelNode
    let stressBackground: SKSpriteNode
    
    let levelLabel: SKLabelNode
    let levelBackground: SKSpriteNode
    
    let waitSecondsBeforeAnotherEnemy: CGFloat
    
    let enemySpeedMultiplier:CGFloat  = 3.0
    
    init(size: CGSize, gameTimeSeconds: Int, damageCaused: Int, maxStessAllowed: Int, waitSecondsBeforeAnotherEnemy: CGFloat, enemySpeedMultiplier: CGFloat = 3.0) {
        topBackground1 = Background(imageNamed: getLevelTopBackgroundName(level: UserConfig.shared.getCurrentLevel()))
        topBackground1.scale(to: CGSize(width: size.width, height: size.height/1.25))
        topBackground1.anchorPoint = CGPointZero
        topBackground1.position = CGPoint(x: 0, y: size.height/5)
        topBackground1.zPosition = -1
        
        topBackground2 = Background(imageNamed: getLevelTopBackgroundName(level: UserConfig.shared.getCurrentLevel()))
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
        
        pauseNode = PauseNode(size: size)
        
        stressBackground = SKSpriteNode(imageNamed: Constants.startGameBaseButton)
        stressBackground.scale(to: CGSize(width: 200, height: 50))
        stressBackground.position = CGPoint(x: size.width/8, y: size.height - 50)
        stressBackground.zPosition = 0
        
        stressLabel = SKLabelNode(fontNamed: Constants.fontName)
        stressLabel.fontSize = 20
        stressLabel.position = stressBackground.position
        stressLabel.horizontalAlignmentMode = .center
        stressLabel.verticalAlignmentMode = .baseline
        stressLabel.fontColor = .black
        stressLabel.text = "Stress: \(self.currentStressMeter)/\(maxStessAllowed)"
        
        levelBackground = SKSpriteNode(imageNamed: Constants.startGameBaseButton)
        levelBackground.scale(to: CGSize(width: 100, height: 50))
        levelBackground.position = CGPoint(x: pauseNode.pauseButton.position.x, y:pauseNode.pauseButton.position.y - 50)
        levelBackground.zPosition = 0
        
        levelLabel = SKLabelNode(fontNamed: Constants.fontName)
        levelLabel.fontSize = 20
        levelLabel.position = levelBackground.position
        levelLabel.horizontalAlignmentMode = .center
        levelLabel.verticalAlignmentMode = .baseline
        levelLabel.fontColor = .black
//        levelLabel.text = "Level \(UserConfig.shared.getCurrentLevel())"
        levelLabel.text = getLevelName(level: UserConfig.shared.getCurrentLevel())
        
        timerBackground = SKSpriteNode(imageNamed: Constants.startGameBaseButton)
        timerBackground.scale(to: CGSize(width: 100, height: 50))
        timerBackground.position = CGPoint(x: stressBackground.position.x, y: stressBackground.position.y - 50)
        timerBackground.zPosition = 0
        
        timerLabel = SKLabelNode(fontNamed: Constants.fontName)
        timerLabel.fontSize = 20
        timerLabel.position = timerBackground.position
        timerLabel.horizontalAlignmentMode = .center
        timerLabel.verticalAlignmentMode = .baseline
        timerLabel.fontColor = .black
        self.maxStessAllowed = maxStessAllowed
        self.waitSecondsBeforeAnotherEnemy = waitSecondsBeforeAnotherEnemy
        super.init(size: size)

        SoundManager.shared.stopSounds()
        SoundManager.shared.playSoundTrack()
        
        self.gameTimeSeconds = gameTimeSeconds
        self.damageCaused = damageCaused
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        // Call here so the safeAreaInsets are set
        playerPlayableRect = determinePlayerPlayableArea()
        
        // Physics World
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        physicsWorld.contactDelegate = self
        
        addChild(topBackground1)
        addChild(topBackground2)
        addChild(bottomBackground)
        addChild(playerModel.node)
        addChild(groundModel.node)
        addChild(cameraNode)
        addChild(pauseNode)
        addChild(stressBackground)
        addChild(stressLabel)
        addChild(timerBackground)
        addChild(timerLabel)
        
        addChild(levelBackground)
        addChild(levelLabel)
        for child in controlsModel.getChildren() {
            addChild(child)
        }
        
        WeaponsManager.shared.resetWeapons(level: UserConfig.shared.getCurrentLevel(), scene: self, boundingRect: controlsModel.getWeaponSelectionBoundingRect())
        controlsModel.updateSelectedWeapon(weaponName: WeaponsManager.shared.getSelectedWeaponName())
        
        spawnEnemyForever()
        startGameTimer()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            // Check if we should vibrate Node Selected
            if(shouldVibrate(node: touchedNode as? VibrateProtocol)) {
                vibrate(with: .light)
            }
            
            determineActionBasedOn(touchedNode: touchedNode, touch: touch, checkOnPause: true)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            if let button = activeTouches[touch] {
                if !button.contains(location) {
                    if !UserConfig.shared.isPaused() {
                        deactivate(button: button, baseTextureName: controlsModel.getBaseTextureName(button)!)
                        playerModel.stopPlayerWalkingAnimation()
                        playerModel.animateIdle()
                        activeTouches[touch] = nil
                    }
                    determineActionBasedOn(touchedNode: touchedNode, touch: touch)
                }
            } else {
                determineActionBasedOn(touchedNode: touchedNode, touch: touch)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if let button = activeTouches[touch] {
                deactivate(button: button, baseTextureName: controlsModel.getBaseTextureName(button)!)
                activeTouches[touch] = nil
                playerModel.stopPlayerWalkingAnimation()
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if let button = activeTouches[touch] {
                deactivate(button: button, baseTextureName: controlsModel.getBaseTextureName(button)!)
                activeTouches[touch] = nil
                playerModel.stopPlayerWalkingAnimation()
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        movePlayerAndBackground()
    }
    
    func determineActionBasedOn(touchedNode: SKNode, touch: UITouch, checkOnPause: Bool = false) {
        if (checkOnPause){
            if let scene = self.view?.scene {
                pauseNode.checkPauseNodePressed(scene: scene, touchedNode: touchedNode)
            }
            
            pauseResume()
        }
        
        if (!UserConfig.shared.paused) {
            switch touchedNode {
            case is LeftArrowButton:
                leftButtonPressed(touch: touch)
                break
            case is RightArrowButton:
                rightButtonPressed(touch: touch)
                break
            case is JumpLabel:
                jumpButtonPressed(touch: touch)
                break
            case is JumpButton:
                jumpButtonPressed(touch: touch)
                break
            case is WeaponButton:
                weaponSlotButtonPressed(nodeSelected: touchedNode)
                break
            case is AttackButton:
                attackButtonPressed(touch: touch)
                break
            case is AttackLabel:
                attackButtonPressed(touch: touch)
                break
            default:
                break
            }
        }
        
    }
    
    func pauseResume() {
        if(UserConfig.shared.isPaused()) {
            pauseSpawnEnemyForever()
            playerModel.stopAllActions()
            stopGameTimer()
        } else {
            spawnEnemyForever()
            playerModel.animateIdle()
            startGameTimer()
            
        }
    }
    
    func weaponSlotButtonPressed(nodeSelected: SKNode) {
        if let weaponSlotSelected = nodeSelected as? WeaponButton {
            // Update Selected Weapon For All
            WeaponsManager.shared.updateSelectedWeapon(node: weaponSlotSelected)
            controlsModel.updateSelectedWeapon(weaponName: WeaponsManager.shared.getSelectedWeaponName())
        }
    }
    
    func leftButtonPressed(touch: UITouch) {
        activeTouches[touch] = controlsModel.leftArrowButton
        animateButtonPressed(button: controlsModel.leftArrowButton, baseTextureName: controlsModel.getBaseTextureName(controlsModel.leftArrowButton)!)
    }
    
    func rightButtonPressed(touch: UITouch) {
        activeTouches[touch] = controlsModel.rightArrowButton
        animateButtonPressed(button: controlsModel.rightArrowButton, baseTextureName: controlsModel.getBaseTextureName(controlsModel.rightArrowButton)!)
    }
    
    func jumpButtonPressed(touch: UITouch) {
        animateButtonPressed(button: controlsModel.jumpButton, baseTextureName: controlsModel.getBaseTextureName(controlsModel.jumpButton)!)
        self.run(waitForAnimation) {
            deactivate(button: self.controlsModel.jumpButton, baseTextureName: self.controlsModel.getBaseTextureName(self.controlsModel.jumpButton)!)
        }
        
        playerModel.playerJump()
    }
    
    func attackButtonPressed(touch: UITouch) {
        var isMoving:Bool = true
        if (!activeTouches.values.contains(self.controlsModel.leftArrowButton) && !activeTouches.values.contains(self.controlsModel.rightArrowButton)) {
            isMoving = false
        }
        
        playerModel.attack(weaponModel: WeaponsManager.shared.getSelectedWeapon(), scene: self, isMoving: isMoving)
    }
    
   func determinePlayerPlayableArea(rightMarginMultiplier: CGFloat = 2.0, leftMargingMultiplier: CGFloat = 2.75) -> CGRect{
        let maxAspectRatio:CGFloat = 16.0 / 9.0
        let playableHeight = size.width / maxAspectRatio
        return CGRect(
            x: (self.view?.safeAreaInsets.left ?? 0.0) * rightMarginMultiplier,
            y: playerModel.node.position.y,
            width: size.width - (self.view?.safeAreaInsets.right ?? 0.0) * leftMargingMultiplier,
            height: playableHeight)
    }
    
    func startGameTimer() {
        if action(forKey: SceneActions.gamer_timer) == nil {
            run(
                SKAction.repeatForever(
                    SKAction.sequence([
                        SKAction.run(countdown),
                        SKAction.wait(forDuration: 1)
                    ])
                ),
                withKey: SceneActions.gamer_timer
            )
        }
    }
    
    func stopGameTimer() {
        if action(forKey: SceneActions.gamer_timer) != nil {
            removeAction(forKey: SceneActions.gamer_timer)
        }
    }
    
    func gameOver() {
        // Pause All Actions Transition To Main Menu
        scene?.removeAllActions()
        SceneTransitioner.shared.transition(self, toScene: LevelLostScene(size: size))
    }
    
    func wonGame() {
        scene?.removeAllActions()
        SceneTransitioner.shared.transition(self, toScene: LevelWonScene(size: size))
    }
    
    func countdown() {
        if (!UserConfig.shared.isPaused()) {
            if (gameTimeSeconds <= 0) {
                // Check Score
                if currentStressMeter < maxStessAllowed {
                    // Transition Back To Main Menu
                    SceneTransitioner.shared.transition(self, toScene: LevelWonScene(size: size))
                } else {
                    SceneTransitioner.shared.transition(self, toScene: LevelLostScene(size: size))
                }
            } else {
                gameTimeSeconds -= 1
            }
        }
    }
    
    func spawnEnemyForever() {
        if action(forKey: SceneActions.spawn_enemy_action) == nil {
            run(
                SKAction.repeatForever(SKAction.sequence([
                    spawnEnemy(),
                    SKAction.wait(forDuration: waitSecondsBeforeAnotherEnemy)
                ])), withKey: SceneActions.spawn_enemy_action
            )
        }
    }
    
    func pauseSpawnEnemyForever() {
        if action(forKey: SceneActions.spawn_enemy_action) != nil {
            removeAction(forKey: SceneActions.spawn_enemy_action)
        }
        cleanUpEnemyActions()
        
    }
    
    func spawnEnemy() -> SKAction {
        return SKAction.run {
            let enemy = self.getRandomEnemy()
            
            enemy.node.name = "enemy"
            enemy.node.position = CGPoint(
                x: self.size.width + enemy.node.size.width/2,
                y: self.playerModel.node.position.y
            )
            self.enemies.append(enemy.node)
            
            self.addChild(enemy.node)
            let actionMove = SKAction.moveTo(x: -enemy.node.size.width/2, duration: self.playerModel.movementSpeed * self.enemySpeedMultiplier)
            let actionRemove = SKAction.removeFromParent()
            enemy.node.run(SKAction.sequence([actionMove, actionRemove]), withKey: SceneActions.move_enemy)
        }
    }
    
    func getRandomEnemy() -> EnemyModel {
        fatalError("getRandomEnemy not implemented")
    }
    
    func movePlayerAndBackground(){
        // Moving Player Left -> Background Moves to the right
        if (playerModel.allowedToMovePlayer()) {
            if (activeTouches.values.contains(controlsModel.leftArrowButton)) {
                moveBackground(direction: .right)
                playerModel.movePlayer(direction: .left)
                playerModel.startPlayerWalkingAnimation(direction: .left)
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
                playerModel.startPlayerWalkingAnimation(direction: .right)
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
}

extension BaseLevelScene:  SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let contactA = contact.bodyA.categoryBitMask
        let contactB = contact.bodyB.categoryBitMask
        if (contactA == PhysicsCategory.player && contactB == PhysicsCategory.ground) ||
           (contactA == PhysicsCategory.ground && contactB == PhysicsCategory.player) {
            playerCollideWithFloor()
        }

        if (contactA == PhysicsCategory.player && contactB == PhysicsCategory.enemy) ||
           (contactA == PhysicsCategory.enemy && contactB == PhysicsCategory.player) {
            var enemyNode = contact.bodyB.node
            if (!(contact.bodyA.node is PlayerNode)) {
                enemyNode = contact.bodyA.node
            }
            
            if (ceil(playerModel.node.position.y) > ceil(enemyNode?.position.y ?? size.height)) {
                EnemyModel.animateTakingDamage(node: enemyNode as! EnemyNode)
            } else {
                if enemyNode?.action(forKey: SceneActions.enemy_taking_damage) == nil {
                    enemyNode?.removeFromParent()
                    playerModel.takeDamage()
                    currentStressMeter += damageCaused
                }
            }
        }
        
        if (contactA == PhysicsCategory.enemy && contactB == PhysicsCategory.projictile) ||
           (contactA == PhysicsCategory.projictile && contactB == PhysicsCategory.enemy) {
            var enemyNode = contact.bodyA.node
            if (!(contact.bodyA.node is EnemyNode)) {
                enemyNode = contact.bodyB.node
            }
            
            EnemyModel.animateTakingDamage(node: enemyNode as! EnemyNode)
        }
        
    }
    
    
    func cleanUpEnemyActions() {
        for enemy in enemies {
            if enemy.parent != nil {
                enemy.removeAllActions()
                enemy.removeFromParent()
            }
        }
    }
    
    func playerCollideWithFloor() {
        if playerModel.isJumping {
            playerModel.collideWithFloor()
            
            if (!activeTouches.values.contains(self.controlsModel.leftArrowButton) && !activeTouches.values.contains(self.controlsModel.rightArrowButton)) {
                playerModel.animateIdle()
            }
        }
    }
    
    func playerCollideWithEnemy() {
        
    }
}
