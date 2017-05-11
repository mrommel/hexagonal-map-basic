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
    
    var map: Map?
    var onFocusChanged: FocusChangedBlock?
    var onTileSelected: FocusChangedBlock?
    
    override init(size: CGSize) {
        super.init(size: size)
        scaleMode = .resizeFill
        
        let terrain = TerrainSpriteNode(withPosition: CGPoint(x: 100, y: 200), andTerrain: .grass)
        self.addChild(terrain)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
