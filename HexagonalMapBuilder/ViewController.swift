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
    //var skScene: SKScene!
    //var scnScene: GameScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.sceneView?.backgroundColor = .brown
        
        self.setupScene()
    }
    
    func setupScene() {
        
        // create a new scene
        let scene = EmptyScene()
        self.sceneView?.pointOfView = scene.fixedCameraNode
        self.sceneView?.scene = scene
        self.sceneView?.allowsCameraControl = true
        self.sceneView?.showsStatistics = true
        //		self.sceneView? = [SCNDebugOptions.ShowWireframe]
        self.sceneView?.backgroundColor = NSColor.gray
        
        self.sceneView?.overlaySKScene = GameScene(size: (self.sceneView?.frame.size)!)
        
        /*self.skScene = self.sceneView?.overlaySKScene
        
        let scnScene = GameScene(size: CGSize(width: 1024, height: 800))
        scnScene.onFocusChanged = { focus in
            if let focus = focus {
                print("changed")
            }
        }
        
        let options = GridGeneratorOptions(withSize: .small,zone: .earth, waterPercentage: 0.4, rivers: 5)
        
        scnScene.map = Map(withOptions: options)
        self.skScene.addChild(scnScene)*/
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

}

