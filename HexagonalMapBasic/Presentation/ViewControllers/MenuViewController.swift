//
//  MenuViewController.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 06.02.17.
//  Copyright © 2017 MARK BROWNSWORD. All rights reserved.
//

import UIKit
import HexagonalMapKit

class MenuViewController: UIViewController {

    let menuEntries = ["New Game", "Setup Game", "Load Game", "Options", "Credits"]
    
    override func viewDidLoad() {

    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    @IBAction func startGame(sender: AnyObject) {
        
        guard let mapViewController = MapViewController.instantiateFromStoryboard("Main") else {
            let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        self.navigationController?.pushViewController(mapViewController, animated: true)
    }

}
