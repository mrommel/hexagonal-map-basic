//
//  GameScene.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 08.02.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import UIKit
import SpriteKit

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func * (point: CGPoint, scalar: CGPoint) -> CGPoint {
    return CGPoint(x: point.x * scalar.x, y: point.y * scalar.y)
}

func / (point: CGPoint, scalar: CGPoint) -> CGPoint {
    return CGPoint(x: point.x / scalar.x, y: point.y / scalar.y)
}

typealias FocusChangedBlock = (_ focus: GridPoint?) -> Void

class GameScene: SKScene {
    
    var grid: Grid?
    var onFocusChanged: FocusChangedBlock?
    var onTileSelected: FocusChangedBlock?
    var cam: SKCameraNode!
    
    let terrainView: SKSpriteNode
    let layer2DHighlight: SKNode
    
    // cursor handling
    var cursorNode: SKSpriteNode
    var cursorPoint: GridPoint?
    
    let tileSize = (width:64, height:64)
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(size: CGSize) {
        
        self.terrainView = SKSpriteNode()
        self.layer2DHighlight = SKNode()
        self.cursorNode = SKSpriteNode(imageNamed: "Selection")
        self.cursorPoint = GridPoint(x: 0, y: 0)
        
        super.init(size: size)
        self.anchorPoint = CGPoint(x:0.5, y:0.5)
    }

    override func didMove(to view: SKView) {
        
        let deviceScale = self.size.width / 667
        
        self.terrainView.position = CGPoint(x:-self.size.width*0.5, y:-self.size.height*0.2)
        self.terrainView.xScale = deviceScale
        self.terrainView.yScale = deviceScale
        self.addChild(terrainView)
        
        self.layer2DHighlight.zPosition = 999
        self.terrainView.addChild(self.layer2DHighlight)
        
        self.placeAllTiles2D()
        
        self.cam = SKCameraNode() //initialize and assign an instance of SKCameraNode to the cam variable.
        self.cam.xScale = 1 // 0.25
        self.cam.yScale = 1 // 0.25 //the scale sets the zoom level of the camera on the given position
        
        self.camera = cam //set the scene's camera to reference cam
        self.addChild(cam) //make the cam a childElement of the scene itself.
        
        // position the camera on the gamescene.
        self.cam.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        // cursor
        self.cursorNode.anchorPoint = CGPoint(x: 0, y: 0)
        self.layer2DHighlight.addChild(self.cursorNode)
    }
    
    func placeAllTiles2D() {
        
        let width: Int = (self.grid?.width)!
        let height: Int = (self.grid?.height)!
        
        for x in 0..<width {
            
            for y in 0..<height {
                
                let gridPoint = GridPoint(x: x, y: y)
                let point = self.grid?.screenPoint(from: gridPoint)
                let tile = self.grid?.tile(at: gridPoint)
                
                place(tile: tile!, withPosition: point!)
            }
        }
    }
    
    func place(tile: Tile, withPosition: CGPoint) {
        
        let terrain = tile.terrain
        
        let tileSprite = SKSpriteNode(imageNamed: (terrain?.image)!)
        tileSprite.position = withPosition
        tileSprite.anchorPoint = CGPoint(x:0, y:0)
        tileSprite.zPosition = 20
        
        self.terrainView.addChild(tileSprite)
        
        for feature in tile.features {
            let featureSprite = SKSpriteNode(imageNamed: feature.image)
            featureSprite.position = withPosition
            featureSprite.anchorPoint = CGPoint(x:0, y:0)
            featureSprite.zPosition = 30
            
            self.terrainView.addChild(featureSprite)
        }
        
        // grid
        let gridSprite = SKSpriteNode(imageNamed: "Grid")
        gridSprite.position = withPosition
        gridSprite.anchorPoint = CGPoint(x:0, y:0)
        gridSprite.zPosition = 100
        
        self.terrainView.addChild(gridSprite)
    }
    
    func moveFocus(to gridpoint: GridPoint) {

        self.cursorNode.position = (self.grid?.screenPoint(from: gridpoint))!
    }
    
    // handling touches
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        let touchLocation = touch?.location(in: self.terrainView)
        
        let gridPoint = self.grid?.gridPoint(from: touchLocation!)
        
        //NSLog("touch hex: \(gridPoint)")
        
        // update the rendering
        self.moveFocus(to: gridPoint!)
        
        // notify parent
        if self.cursorPoint == gridPoint {
            if let focusChanged = self.onFocusChanged {
                focusChanged(gridPoint)
            }
        }
        self.cursorPoint = gridPoint
    }
    
    // moving the map around
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self.terrainView)
            let previousLocation = touch.previousLocation(in: self.terrainView)
            let deltaX = (location.x) - (previousLocation.x)
            let deltaY = (location.y) - (previousLocation.y)

            self.cam.position.x -= deltaX * 0.5
            self.cam.position.y -= deltaY * 0.5
        }
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        //NSLog("update")
    }
}
