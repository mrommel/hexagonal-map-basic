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
    
    let terrainTransitionManager: TerrainTransitionManager
    
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
        self.terrainTransitionManager = TerrainTransitionManager()
        
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
                
                place(tile: tile!, gridPoint: gridPoint, withPosition: point!)
            }
        }
    }
    
    // render tile
    // 
    // zlevel
    // 60 units
    // 50 features
    // 40 focus/cursor
    // 30 grid
    // 20 terrain transitions
    // 10 terrain
    //
    func place(tile: Tile, gridPoint: GridPoint, withPosition position: CGPoint) {
        
        let terrain = tile.terrain
        
        let tileSprite = SKSpriteNode(imageNamed: (terrain?.image)!)
        tileSprite.position = position
        tileSprite.anchorPoint = CGPoint(x:0, y:0)
        tileSprite.zPosition = 10
        self.terrainView.addChild(tileSprite)
        
        // terrain transitions
        let neighborNE = gridPoint.neighbor(in: .northEast)
        let remoteNE = self.grid?.tile(at: neighborNE).terrain!
        
        let neighborSE = gridPoint.neighbor(in: .southEast)
        let remoteSE = self.grid?.tile(at: neighborSE).terrain!
        
        let neighborS = gridPoint.neighbor(in: .south)
        let remoteS = self.grid?.tile(at: neighborS).terrain!
        
        let neighborSW = gridPoint.neighbor(in: .southWest)
        let remoteSW = self.grid?.tile(at: neighborSW).terrain!
        
        let neighborNW = gridPoint.neighbor(in: .northWest)
        let remoteNW = self.grid?.tile(at: neighborNW).terrain!
        
        let neighborN = gridPoint.neighbor(in: .north)
        let remoteN = self.grid?.tile(at: neighborN).terrain!
        
        if let transitions = self.terrainTransitionManager.bestTransitions(forCenter: terrain!, remoteNE: remoteNE!, remoteSE: remoteSE!, remoteS: remoteS!, remoteSW: remoteSW!, remoteNW: remoteNW!, remoteN: remoteN!) {
            
            for transition in transitions {
                print("transitionImage=\(transition)")
            
                let transitionSprite = SKSpriteNode(imageNamed: transition.image)
                transitionSprite.position = position
                transitionSprite.anchorPoint = CGPoint(x:0, y:0)
                transitionSprite.zPosition = CGFloat(transition.zLevel)
            
                self.terrainView.addChild(transitionSprite)
            }
        }
        
        
        // grid
        self.terrainView.addChild(GridSpriteNode(withPosition: position))
        
        // features
        for feature in tile.features {
            let featureSprite = SKSpriteNode(imageNamed: feature.image)
            featureSprite.position = position
            featureSprite.anchorPoint = CGPoint(x:0, y:0)
            featureSprite.zPosition = 50
            
            self.terrainView.addChild(featureSprite)
        }

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
