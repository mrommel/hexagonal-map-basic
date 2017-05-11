//
//  MapEditViewController.swift
//  HexagonalMapBuilder
//
//  Created by Michael Rommel on 19.04.17.
//  Copyright © 2017 MiRo Soft. All rights reserved.
//

import Cocoa
import Foundation
import SceneKit
import SpriteKit
import HexagonalMapKit

class MapEditViewController: NSViewController {

    @IBOutlet var sceneView: SCNView?
    @IBOutlet var statusLabel: NSTextField?
    var gameScene: GameScene!
    
    var controller: MapEditController? {
        willSet {
            controller?.viewDelegate = nil
        }
        didSet {
            controller?.viewDelegate = self
            refreshDisplay()
        }
    }
    
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
        self.sceneView?.backgroundColor = NSColor.gray
        
        self.gameScene = GameScene(size: (self.sceneView?.frame.size)!)
        self.sceneView?.overlaySKScene = self.gameScene
        
        self.statusLabel?.stringValue = "test"
    }

    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }

    func refreshDisplay() {
        
    }
}

extension MapEditViewController: MapEditControllerViewDelegate
{
    func displayErrorMessage(editController: MapEditController, message: String)
    {
        guard let window = view.window else { return}
        
        let alert = NSAlert()
        alert.addButton(withTitle: "OK")
        alert.messageText = message
        //alert.alertStyle = NSAlertStyleCritical
        alert.beginSheetModal(for: window, completionHandler: nil)
    }
    
    
    func mapDidChange(editController: MapEditController) {
        refreshDisplay()
    }
}

