//
//  BossLevelScene.swift
//  Sprint
//
//  Created by Ghaida Atoum on 12/16/24.
//

import Foundation
import SpriteKit

class BossLevelScene: BaseLevelScene {
    
    init(size: CGSize) {
        super.init(size: size, gameTimeSeconds: getLevelDuration(level: 3), damageCaused: 30, maxStessAllowed: 70, waitSecondsBeforeAnotherEnemy: 1.0, enemySpeedMultiplier: 5.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func getRandomEnemy() -> EnemyModel {
        let nodes = [
            EnemyModel(size: self.playerModel.node.size, node: EnemyNode(imageNamed: "level0_enemy0")),
            EnemyModel(size: self.playerModel.node.size, node: EnemyNode(imageNamed: "level0_enemy1")),
            EnemyModel(size: self.playerModel.node.size, node: EnemyNode(imageNamed: "level0_enemy2")),
            EnemyModel(size: self.playerModel.node.size, node: EnemyNode(imageNamed: "level1_enemy0")),
            EnemyModel(size: self.playerModel.node.size, node: EnemyNode(imageNamed: "level1_enemy1")),
            EnemyModel(size: self.playerModel.node.size, node: EnemyNode(imageNamed: "level1_enemy2")),
            EnemyModel(size: self.playerModel.node.size, node: EnemyNode(imageNamed: "level2_enemy0")),
            EnemyModel(size: self.playerModel.node.size, node: EnemyNode(imageNamed: "level2_enemy1")),
            EnemyModel(size: self.playerModel.node.size, node: EnemyNode(imageNamed: "boss"))
        ]
        let randomIndex = Int(arc4random_uniform(UInt32(nodes.count)))
        return nodes[randomIndex]
    }
}