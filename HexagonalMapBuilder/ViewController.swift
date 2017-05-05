//
//  ViewController.swift
//  HexagonalMapBuilder
//
//  Created by Michael Rommel on 19.04.17.
//  Copyright © 2017 MiRo Soft. All rights reserved.
//

import Cocoa
import Foundation
import SceneKit
import SpriteKit
import HexagonalMap

class ViewController: NSViewController {

    @IBOutlet var sceneView: SCNView?
    var gameScene: GameScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.sceneView?.backgroundColor = .brown
        
        self.setupScene()
        
        //self.menu?.addItem(NSMenuItem(title: "Test", action: nil, keyEquivalent: "t"))
    }
    
    func setupScene() {
        
        // create a new scene
        let scene = EmptyScene()
        self.sceneView?.pointOfView = scene.fixedCameraNode
        self.sceneView?.scene = scene
        self.sceneView?.allowsCameraControl = true
        self.sceneView?.showsStatistics = true
        self.sceneView?.backgroundColor = NSColor.gray
        
        self.gameScene = GameScene(size: (self.sceneView?.frame.size)!)
        self.sceneView?.overlaySKScene = self.gameScene
    }

    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }

}

