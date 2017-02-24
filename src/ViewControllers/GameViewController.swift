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
import CircleMenu

class GameViewController: UIViewController {
    
    let menuItems: [(icon: String, color: UIColor)] = [
        ("Icon_download", UIColor(red:0.19, green:0.57, blue:1, alpha:1)),
        ("Icon_goal", UIColor(red:0.22, green:0.74, blue:0, alpha:1)),
        ("Icon_close", UIColor(red:0.96, green:0.23, blue:0.21, alpha:1)),
        ("Icon_settings", UIColor(red:0.51, green:0.15, blue:1, alpha:1)),
        ("Icon_close", UIColor(red:1, green:0.39, blue:0, alpha:1)),
        ("Icon_close", UIColor(red:1, green:0.39, blue:0, alpha:1)),
        ("Icon_settings", UIColor(red:0.51, green:0.15, blue:1, alpha:1)),
        ("Icon_sharing", UIColor(red:1, green:0.39, blue:0, alpha:1)),
        ]
    
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

    @IBAction func openMenu(sender: AnyObject) {
        
        let alertView = SCLAlertView()
        alertView.addButton("Turn") {
            print("Turn")
        }
        alertView.addButton("Exit Game") {
            print("Exit")
            _ = self.navigationController?.popViewController(animated: true)
        }
        alertView.showSuccess("Menu", subTitle: "Select one of the options")
    }
}
