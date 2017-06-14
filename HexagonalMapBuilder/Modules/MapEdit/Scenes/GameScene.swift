//
//  GameScene.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 27.04.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation
import SpriteKit
import HexagonalMapKit

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

class GameScene: SKScene {
    
    var base: SKNode
    var cursorNode: SKSpriteNode
    
    let terrainTransitionManager: TerrainTransitionManager
    let featureTransitionManager: FeatureTransitionManager
    let riverTransitionManager: RiverTransitionManager

    override init(size: CGSize) {
        
        self.base = SKNode()
        
        self.cursorNode = SKSpriteNode(imageNamed: "Selection")
        self.cursorNode.zPosition = 40.0
        self.cursorNode.anchorPoint = CGPoint(x: 0, y: 0)
        self.base.addChild(self.cursorNode)
        
        self.terrainTransitionManager = TerrainTransitionManager()
        self.featureTransitionManager = FeatureTransitionManager()
        self.riverTransitionManager = RiverTransitionManager()
        
        super.init(size: size)
        scaleMode = .resizeFill

        self.addChild(base)
    }
    
    var map: Map? {
        didSet {
            self.clearBaseNode()
            self.placeAllTiles2D()
        }
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension GameScene {
    
    func moveFocus(to gridpoint: GridPoint) {
        
        let screenPoint = (self.map?.grid?.screenPoint(from: gridpoint))!
        self.cursorNode.position = screenPoint
    }
    
    public func offsetTo(x: CGFloat, y: CGFloat) {
        self.base.position.x = x
        self.base.position.y = y
    }
    
    func clearBaseNode() {
        self.base.removeAllChildren()
    }
    
    func placeAllTiles2D() {
        
        guard map != nil else {
            return
        }
        
        guard let width: Int = self.map!.grid?.width else {
            return
        }
        guard let height: Int = self.map!.grid?.height else {
            return
        }
        
        for x in 0..<width {
            
            for y in 0..<height {
                
                let gridPoint = GridPoint(x: x, y: y)
                var point = self.map?.grid?.screenPoint(from: gridPoint)
                
                // skscene is up-side-down
                point?.y = 300 - (point?.y)!
                
                let tile = self.map?.grid?.tile(at: gridPoint)
                
                self.place(tile: tile!, gridPoint: gridPoint, withPosition: point!)
            }
        }
    }
    
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
            //self.terrainView.addChild(CitySpriteNode(withPosition: position, andCity: city))
            print("\(city)")
        }
        
        // units
        
    }
    
    func addGridSprite(at position: CGPoint) {
        
        self.base.addChild(GridSpriteNode(withPosition: position))
    }
    
    func addFeatureSprites(tile: Tile, gridPoint: GridPoint, at position: CGPoint) {
        
        // add feature pictures
        for feature in tile.features {
            self.base.addChild(FeatureSpriteNode(withPosition: position, andFeature: feature))
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
                self.base.addChild(TransitionSpriteNode(withPosition: position, andTransition: transition))
            }
        }
    }
    
    func addTerrainSprites(tile: Tile, gridPoint: GridPoint, at position: CGPoint) {
        
        let terrain = tile.terrain
        
        // terrain sprite
        self.base.addChild(TerrainSpriteNode(withPosition: position, andTerrain: terrain))
        
        // terrain transitions
        let remoteNE = self.map?.grid?.tile(at: gridPoint.neighbor(in: .northEast)).terrain
        let remoteSE = self.map?.grid?.tile(at: gridPoint.neighbor(in: .southEast)).terrain
        let remoteS = self.map?.grid?.tile(at: gridPoint.neighbor(in: .south)).terrain
        let remoteSW = self.map?.grid?.tile(at: gridPoint.neighbor(in: .southWest)).terrain
        let remoteNW = self.map?.grid?.tile(at: gridPoint.neighbor(in: .northWest)).terrain
        let remoteN = self.map?.grid?.tile(at: gridPoint.neighbor(in: .north)).terrain
        let remotePattern = "\((remoteNE?.rawValue)!),\((remoteSE?.rawValue)!),\((remoteS?.rawValue)!),\((remoteSW?.rawValue)!),\((remoteNW?.rawValue)!),\((remoteN?.rawValue)!)"
        
        if let transitions = self.terrainTransitionManager.bestTransitions(forCenter: terrain, remotePattern: remotePattern) {
            
            for transition in transitions {
                
                self.base.addChild(TransitionSpriteNode(withPosition: position, andTransition: transition))
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
                self.base.addChild(TransitionSpriteNode(withPosition: position, andTransition: transition))
            }
        }
    }
}
