//
//  ViewController.swift
//  HexagonalMapBuilder
//
//  Created by Michael Rommel on 19.04.17.
//  Copyright © 2017 MiRo Soft. All rights reserved.
//

import Cocoa
import SceneKit
import HexagonalMap

class ViewController: NSViewController {

    @IBOutlet var sceneView: SCNView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.sceneView?.backgroundColor = .brown
        
        //let motionKit = SwiftFrameworks()
        //motionKit.doSomething()
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

}

