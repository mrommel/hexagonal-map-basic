//
//  GameViewController.swift
//
//  Created by MARK BROWNSWORD on 24/7/16.
//  Copyright © 2016 MARK BROWNSWORD. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import SCLAlertView

class GameViewController: UIViewController {
    
    // MARK: Property Overrides
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    
    // MARK: Function overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = GameScene(size: view.bounds.size)
        scene.onFocusChanged = { focus in
            SCLAlertView().showInfo("Important info", subTitle: "You are great")
        }
        
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        
        let generator = GridGenerator(width: 20, height: 20)
        generator?.fillFromElevation(withWaterPercentage: 0.5)
        scene.grid = generator?.generate()
        
        scene.grid?.add(feature: Feature.forest, at: GridPoint(x: 2, y: 2))
        
        skView.presentScene(scene)
    }
    
}
