//
//  GameViewController.swift
//  InverseKinematics
//
//  Created by Ilya B Macmini on 28/03/2020.
//  Copyright © 2020 ilyabiltuev. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if let scene = GameScene(fileNamed: "GameScene") {
            
            scene.scaleMode = .aspectFit
            
            let skView = view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            skView.ignoresSiblingOrder = true
            
            skView.presentScene(scene)
        }
    }
    
    override var shouldAutorotate: Bool {
        
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        
        return .portrait
    }
    
    override var prefersStatusBarHidden: Bool {
        
        return true
    }
}
