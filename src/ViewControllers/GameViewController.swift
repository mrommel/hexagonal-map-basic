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

class GameViewController: UIViewController, CircleMenuDelegate {
    
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
        
        let button = CircleMenu(
            frame: CGRect(x: (self.view.frame.width - 50) / 2 , y: (self.view.frame.height - 60), width: 50, height: 50),
            normalIcon: "Icon_home",
            selectedIcon: "Icon_close",
            buttonsCount: 8, // only 5 will be visible
            duration: 0.7,
            distance: 120)
        button.delegate = self
        button.layer.cornerRadius = button.frame.size.width / 2.0
        view.addSubview(button)
    }

}

// MARK: <CircleMenuDelegate>

extension GameViewController {

    func circleMenu(_ circleMenu: CircleMenu, willDisplay button: UIButton, atIndex: Int) {
        
        button.backgroundColor = menuItems[atIndex].color
        button.setImage(UIImage(named: menuItems[atIndex].icon), for: .normal)
        button.tintColor = UIColor.init(colorLiteralRed: 1.0, green: 1.0, blue: 1.0, alpha: 0.5) // make icon white with transparency
        
        // set highlighted image
        let highlightedImage  = UIImage(named: menuItems[atIndex].icon)?.withRenderingMode(.alwaysTemplate)
        button.setImage(highlightedImage, for: .highlighted)
        
    }
    
    func circleMenu(_ circleMenu: CircleMenu, buttonDidSelected button: UIButton, atIndex: Int) {
        
        print("button did selected: \(atIndex)")
        
        switch(atIndex) {
        case 2: // exit
            _ = self.navigationController?.popViewController(animated: true)
            break
        default:
            // noop
            break
        }
    }
}
