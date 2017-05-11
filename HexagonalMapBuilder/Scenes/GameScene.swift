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

typealias FocusChangedBlock = (_ focus: GridPoint?) -> Void

class GameScene: SKScene {

    var onFocusChanged: FocusChangedBlock?
    var onTileSelected: FocusChangedBlock?
    
    var base: SKNode

    override init(size: CGSize) {
        
        self.base = SKNode()
        
        super.init(size: size)
        scaleMode = .resizeFill

        self.addChild(base)
    }
    
    var map: Map? {
        didSet {
            self.placeAllTiles2D()
        }
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension GameScene {
    
    public func moveBy(dx: CGFloat, dy: CGFloat) {
        self.base.position.x += dx
        self.base.position.y += dy
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
        
        let terrain = TerrainSpriteNode(withPosition: position, andTerrain: tile.terrain!)
        self.base.addChild(terrain)
    }
}
