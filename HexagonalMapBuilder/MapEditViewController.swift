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

class GameSceneView: SCNView {
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        // create a new scene
        let scene = EmptyScene()
        self.scene = scene
        self.allowsCameraControl = true
        self.showsStatistics = true
        self.backgroundColor = NSColor.black
        
        self.isPlaying = true
    }
    
    override func mouseDragged(with event: NSEvent) {
        Swift.print("mouseDragged")
    }
    
    override func mouseMoved(with event: NSEvent) {
        Swift.print("mouseMoved")       
    }
    
    override func mouseDown(with event: NSEvent) {
        Swift.print("mouseDown")
        
        if let s = self.overlaySKScene as? GameScene? {
            s?.moveBy(dx: 20, dy: 10)
            //self.needsDisplay = true
        }
    }
    
    override var acceptsFirstResponder: Bool { return true }
    
}

class MapEditViewController: NSViewController {

    @IBOutlet var sceneView: GameSceneView?
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

        self.gameScene = GameScene(size: (self.sceneView?.frame.size)!)
        self.sceneView?.overlaySKScene = self.gameScene

        if let map = self.controller?.map {
            self.statusLabel?.stringValue = "Loaded: \(map.title)"
        }
    }

    func refreshDisplay() {
        self.gameScene.map = self.controller?.map
    }
}

extension MapEditViewController: MapEditControllerViewDelegate {
    
    func displayErrorMessage(editController: MapEditController, message: String) {
        
        guard let window = view.window else { return }

        let alert = NSAlert()
        alert.addButton(withTitle: "OK")
        alert.messageText = message
        alert.beginSheetModal(for: window, completionHandler: nil)
    }


    func mapDidChange(editController: MapEditController) {
        self.refreshDisplay()
    }
}

