//
//  GameSceneView.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 15.05.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation
import SceneKit
import SpriteKit
import HexagonalMapKit

typealias FocusChangedBlock = (_ focus: GridPoint?) -> Void

class GameSceneView: SCNView {
    
    var gameScene: GameScene!
    
    // map handling
    var previousPoint = NSPoint(x: 0, y: 0)
    var offset = NSPoint(x: 0, y: 0)
    
    var onFocusChanged: FocusChangedBlock?
    var focusPoint: GridPoint = GridPoint(x: 0, y: 0)
    
    var map: Map? {
        didSet {
            // forward this map to the scene
            self.gameScene.map = self.map
        }
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        // create a new scene
        self.scene = EmptyScene()
        self.allowsCameraControl = true
        self.showsStatistics = true
        self.backgroundColor = NSColor.black
        
        self.gameScene = GameScene(size: self.frame.size)
        self.overlaySKScene = self.gameScene
        
        self.isPlaying = true
    }
    
    override func mouseDragged(with event: NSEvent) {
        
        let currentPoint = event.locationInWindow
        
        let dx = currentPoint.x - self.previousPoint.x
        let dy = currentPoint.y - self.previousPoint.y
        
        self.offset.x += dx
        self.offset.y += dy
        
        if let scene = self.overlaySKScene as? GameScene? {
            scene?.offsetTo(x: self.offset.x, y: self.offset.y)
        }
        
        self.previousPoint = event.locationInWindow
    }
    
    override func mouseDown(with event: NSEvent) {
        
        let screenPoint = event.locationInWindow
        
        self.previousPoint = screenPoint
        
        if let scene = self.overlaySKScene as? GameScene? {
            
            let screenPointWithoutOffset = screenPoint - self.offset
            
            let gridPoint = self.map?.grid?.gridPoint(from: screenPointWithoutOffset)
            
            if gridPoint != focusPoint {
                self.focusPoint = gridPoint!
                
                self.onFocusChanged!(gridPoint)
                
                scene?.moveFocus(to: self.focusPoint)
            }

            
        }
    }
    
    override var acceptsFirstResponder: Bool { return true }
    
}
