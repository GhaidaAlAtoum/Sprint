//
//  FirstLevelScene.swift
//  Sprint
//
//  Created by Ghaida Atoum on 12/16/24.
//

import Foundation
import SpriteKit

class FirstLevelScene: BaseLevelScene {
    
    init(size: CGSize) {
        super.init(size: size, gameTimeSeconds: getLevelDuration(level: 0), damageCaused: 5, maxStessAllowed: 50, waitSecondsBeforeAnotherEnemy: 5.0, enemySpeedMultiplier: 3.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func getRandomEnemy() -> EnemyModel {
        let nodes = [
            EnemyModel(size: self.playerModel.node.size, node: EnemyNode(imageNamed: "level0_enemy0")),
            EnemyModel(size: self.playerModel.node.size, node: EnemyNode(imageNamed: "level0_enemy1")),
            EnemyModel(size: self.playerModel.node.size, node: EnemyNode(imageNamed: "level0_enemy2"))
        ]
        let randomIndex = Int(arc4random_uniform(UInt32(nodes.count)))
        return nodes[randomIndex]
    }
}
