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

    var map: Map?
    var onFocusChanged: FocusChangedBlock?
    var onTileSelected: FocusChangedBlock?
    var cam: SKCameraNode!

    let terrainTransitionManager: TerrainTransitionManager
    let featureTransitionManager: FeatureTransitionManager
    let riverTransitionManager: RiverTransitionManager
 
    let terrainView: SKSpriteNode
    //let layer2DHighlight: SKNode

    // cursor handling
    var cursorNode: SKSpriteNode
    var cursorPoint: GridPoint?

    let tileSize = (width: 64, height: 64)

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(size: CGSize) {

        self.terrainView = SKSpriteNode()
        self.cursorNode = SKSpriteNode(imageNamed: "Selection")
        self.cursorNode.zPosition = 40.0
        self.cursorPoint = GridPoint(x: 0, y: 0)

        self.terrainTransitionManager = TerrainTransitionManager()
        self.featureTransitionManager = FeatureTransitionManager()
        self.riverTransitionManager = RiverTransitionManager()

        super.init(size: size)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    }

    override func didMove(to view: SKView) {

        let deviceScale = self.size.width / 667

        self.terrainView.position = CGPoint(x: -self.size.width * 0.5, y: -self.size.height * 0.2)
        self.terrainView.xScale = deviceScale
        self.terrainView.yScale = deviceScale
        self.addChild(terrainView)

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
        self.terrainView.addChild(self.cursorNode)
    }

    func placeAllTiles2D() {

        guard let width: Int = self.map!.grid?.width else {
            return
        }
        guard let height: Int = self.map!.grid?.height else {
            return
        }

        for x in 0..<width {

            for y in 0..<height {

                let gridPoint = GridPoint(x: x, y: y)
                let point = self.map?.grid?.screenPoint(from: gridPoint)
                let tile = self.map?.grid?.tile(at: gridPoint)

                place(tile: tile!, gridPoint: gridPoint, withPosition: point!)
            }
        }
    }

    // render tile
    //
    // zlevel
    // 70 units
    // 60 cities
    // 50 features
    // 40 focus/cursor
    // 30 grid
    // 25 river transistions
    // 20 terrain transitions
    // 10 terrain
    //
    func place(tile: Tile, gridPoint: GridPoint, withPosition position: CGPoint) {

        // terrain
        self.addTerrainSprites(tile: tile, gridPoint: gridPoint, at: position)
        
        // river transitions
        self.addRiverSprites(tile: tile, gridPoint: gridPoint, at: position)

        // grid
        self.addGridSprite(at: position)
        
        // features
        self.addFeatureSprites(tile: tile, gridPoint: gridPoint, at: position)
        
        // cities
        if let city = self.map?.city(at: gridPoint) {
            self.terrainView.addChild(CitySpriteNode(withPosition: position, andCity: city))
        }
        
        // units
    }
    
    func addGridSprite(at position: CGPoint) {
        
        self.terrainView.addChild(GridSpriteNode(withPosition: position))
    }
    
    func addFeatureSprites(tile: Tile, gridPoint: GridPoint, at position: CGPoint) {
        
        // add feature pictures
        for feature in tile.features {
            self.terrainView.addChild(FeatureSpriteNode(withPosition: position, andFeature: feature))
        }
        
        // feature transitions
        let featuresNE = self.map?.grid?.tile(at: gridPoint.neighbor(in: .northEast)).features
        let featuresSE = self.map?.grid?.tile(at: gridPoint.neighbor(in: .southEast)).features
        let featuresS = self.map?.grid?.tile(at: gridPoint.neighbor(in: .south)).features
        let featuresSW = self.map?.grid?.tile(at: gridPoint.neighbor(in: .southWest)).features
        let featuresNW = self.map?.grid?.tile(at: gridPoint.neighbor(in: .northWest)).features
        let featuresN = self.map?.grid?.tile(at: gridPoint.neighbor(in: .north)).features
        
        if let transitions = self.featureTransitionManager.bestTransitions(forCenter: tile.features, remotesNE: featuresNE!, remotesSE: featuresSE!, remotesS: featuresS!, remotesSW: featuresSW!, remotesNW: featuresNW!, remotesN: featuresN!) {
            
            for transition in transitions {
                self.terrainView.addChild(TransitionSpriteNode(withPosition: position, andTransition: transition))
            }
        }
    }
    
    func addTerrainSprites(tile: Tile, gridPoint: GridPoint, at position: CGPoint) {
        
        let terrain = tile.terrain
        
        // terrain sprite
        self.terrainView.addChild(TerrainSpriteNode(withPosition: position, andTerrain: terrain!))
        
        // terrain transitions
        let remoteNE = self.map?.grid?.tile(at: gridPoint.neighbor(in: .northEast)).terrain!
        let remoteSE = self.map?.grid?.tile(at: gridPoint.neighbor(in: .southEast)).terrain!
        let remoteS = self.map?.grid?.tile(at: gridPoint.neighbor(in: .south)).terrain!
        let remoteSW = self.map?.grid?.tile(at: gridPoint.neighbor(in: .southWest)).terrain!
        let remoteNW = self.map?.grid?.tile(at: gridPoint.neighbor(in: .northWest)).terrain!
        let remoteN = self.map?.grid?.tile(at: gridPoint.neighbor(in: .north)).terrain!
        let remotePattern = "\((remoteNE?.rawValue)!),\((remoteSE?.rawValue)!),\((remoteS?.rawValue)!),\((remoteSW?.rawValue)!),\((remoteNW?.rawValue)!),\((remoteN?.rawValue)!)"
        
        if let transitions = self.terrainTransitionManager.bestTransitions(forCenter: terrain!, remotePattern: remotePattern) {
            
            for transition in transitions {
                
                self.terrainView.addChild(TransitionSpriteNode(withPosition: position, andTransition: transition))
            }
        }
    }
    
    func addRiverSprites(tile: Tile, gridPoint: GridPoint, at position: CGPoint) {
        
        let flows = self.map?.grid?.flows(at: gridPoint)
        let flowsNE = self.map?.grid?.flows(at: gridPoint.neighbor(in: .northEast))
        let flowsSE = self.map?.grid?.flows(at: gridPoint.neighbor(in: .southEast))
        let flowsS = self.map?.grid?.flows(at: gridPoint.neighbor(in: .south))
        let flowsSW = self.map?.grid?.flows(at: gridPoint.neighbor(in: .southWest))
        let flowsNW = self.map?.grid?.flows(at: gridPoint.neighbor(in: .northWest))
        let flowsN = self.map?.grid?.flows(at: gridPoint.neighbor(in: .north))
        
        if let transitions = self.riverTransitionManager.bestTransitions(forCenter: flows!, remotesNE: flowsNE!, remotesSE: flowsSE!, remotesS: flowsS!, remotesSW: flowsSW!, remotesNW: flowsNW!, remotesN: flowsN!) {
            for transition in transitions {
                self.terrainView.addChild(TransitionSpriteNode(withPosition: position, andTransition: transition))
            }
        }
    }

    func moveFocus(to gridpoint: GridPoint) {

        self.cursorNode.position = (self.map?.grid?.screenPoint(from: gridpoint))!
    }

    // handling touches
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        let touch = touches.first
        let touchLocation = touch?.location(in: self.terrainView)

        let gridPoint = self.map?.grid?.gridPoint(from: touchLocation!)

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
