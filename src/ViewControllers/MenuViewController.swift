//
//  MenuViewController.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 06.02.17.
//  Copyright © 2017 MARK BROWNSWORD. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    let menuEntries = ["New Game", "Setup Game", "Load Game", "Options", "Credits"]
    
    override func viewDidLoad() {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    @IBAction func startGame(sender: AnyObject) {
        let gameViewController = GameViewController.instantiateFromStoryboard("Main")        
        self.navigationController?.pushViewController(gameViewController, animated: true)
    }

}
