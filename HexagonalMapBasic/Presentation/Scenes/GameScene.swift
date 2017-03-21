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
        //self.layer2DHighlight = SKNode()
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
    // 25 river transistions
    // 20 terrain transitions
    // 10 terrain
    //
    func place(tile: Tile, gridPoint: GridPoint, withPosition position: CGPoint) {

        let terrain = tile.terrain

        // terrain sprite
        self.terrainView.addChild(TerrainSpriteNode(withPosition: position, andTerrain: terrain!))

        // terrain transitions
        let remoteNE = self.grid?.tile(at: gridPoint.neighbor(in: .northEast)).terrain!
        let remoteSE = self.grid?.tile(at: gridPoint.neighbor(in: .southEast)).terrain!
        let remoteS = self.grid?.tile(at: gridPoint.neighbor(in: .south)).terrain!
        let remoteSW = self.grid?.tile(at: gridPoint.neighbor(in: .southWest)).terrain!
        let remoteNW = self.grid?.tile(at: gridPoint.neighbor(in: .northWest)).terrain!
        let remoteN = self.grid?.tile(at: gridPoint.neighbor(in: .north)).terrain!
        let remotePattern = "\((remoteNE?.rawValue)!),\((remoteSE?.rawValue)!),\((remoteS?.rawValue)!),\((remoteSW?.rawValue)!),\((remoteNW?.rawValue)!),\((remoteN?.rawValue)!)"

        if let transitions = self.terrainTransitionManager.bestTransitions(forCenter: terrain!, remotePattern: remotePattern) {

            for transition in transitions {

                self.terrainView.addChild(TransitionSpriteNode(withPosition: position, andTransition: transition))
            }
        }
        
        // river transitions
        let flows = self.grid?.flows(at: gridPoint)
        let flowsNE = self.grid?.flows(at: gridPoint.neighbor(in: .northEast))
        let flowsSE = self.grid?.flows(at: gridPoint.neighbor(in: .southEast))
        let flowsS = self.grid?.flows(at: gridPoint.neighbor(in: .south))
        let flowsSW = self.grid?.flows(at: gridPoint.neighbor(in: .southWest))
        let flowsNW = self.grid?.flows(at: gridPoint.neighbor(in: .northWest))
        let flowsN = self.grid?.flows(at: gridPoint.neighbor(in: .north))
        
        
        if let transitions = self.riverTransitionManager.bestTransitions(forCenter: flows!, remotesNE: flowsNE!, remotesSE: flowsSE!, remotesS: flowsS!, remotesSW: flowsSW!, remotesNW: flowsNW!, remotesN: flowsN!) {
        
            for transition in transitions {
                print("river transition: \(transition.image)")
                self.terrainView.addChild(TransitionSpriteNode(withPosition: position, andTransition: transition))
            }
            
        }

        // grid
        self.terrainView.addChild(GridSpriteNode(withPosition: position))

        // features
        for feature in tile.features {

            self.terrainView.addChild(FeatureSpriteNode(withPosition: position, andFeature: feature))
        }
        
        // feature transitions
        let featuresNE = self.grid?.tile(at: gridPoint.neighbor(in: .northEast)).features
        let featuresSE = self.grid?.tile(at: gridPoint.neighbor(in: .southEast)).features
        let featuresS = self.grid?.tile(at: gridPoint.neighbor(in: .south)).features
        let featuresSW = self.grid?.tile(at: gridPoint.neighbor(in: .southWest)).features
        let featuresNW = self.grid?.tile(at: gridPoint.neighbor(in: .northWest)).features
        let featuresN = self.grid?.tile(at: gridPoint.neighbor(in: .north)).features

        if let transitions = self.featureTransitionManager.bestTransitions(forCenter: tile.features, remotesNE: featuresNE!, remotesSE: featuresSE!, remotesS: featuresS!, remotesSW: featuresSW!, remotesNW: featuresNW!, remotesN: featuresN!) {
            
            for transition in transitions {
                
                print("feature transition: \(transition.image)")
                self.terrainView.addChild(TransitionSpriteNode(withPosition: position, andTransition: transition))
            }
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
