//
//  TerrainSpriteNode.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 28.04.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import SpriteKit
import HexagonalMap

class TerrainSpriteNode: SKSpriteNode {
    
    static let zLevel: CGFloat = 10.0
    
    init(withPosition position: CGPoint, andTerrain terrain: Terrain) {
        let texture = SKTexture(imageNamed: terrain.image)
        super.init(texture: texture, color: NSColor.clear, size: texture.size())
        
        self.position = position
        self.anchorPoint = CGPoint(x: 0, y: 0)
        self.zPosition = TerrainSpriteNode.zLevel
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
