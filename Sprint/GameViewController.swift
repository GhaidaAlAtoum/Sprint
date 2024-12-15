//
//  GameViewController.swift
//  Sprint
//
//  Created by Ghaida Atoum on 12/14/24.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillLayoutSubviews() {
        let menuScene = MainMenuScene(size: view.bounds.size)
        menuScene.scaleMode = .aspectFill
        let skView = self.view as! SKView
        skView.presentScene(menuScene)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
