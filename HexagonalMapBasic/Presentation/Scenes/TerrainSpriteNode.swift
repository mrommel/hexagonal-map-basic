//
//  TerrainSpriteNode.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 16.02.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import SpriteKit
import HexagonalMapKit

class TerrainSpriteNode: SKSpriteNode {
    
    static let zLevel: CGFloat = 10.0
    
    init(withPosition position: CGPoint, andTerrain terrain: Terrain) {
        let texture = SKTexture(imageNamed: terrain.image)
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        
        self.position = position
        self.anchorPoint = CGPoint(x: 0, y: 0)
        self.zPosition = TerrainSpriteNode.zLevel
        
        /*if terrain == .ocean {
            
            let textureAtlas = SKTextureAtlas(named: "waves")
            let frames = ["waves-concave-A01-l", "waves-concave-A02-l", "waves-concave-A03-l", "waves-concave-A04-l", "waves-concave-A05-l", "waves-concave-A06-l"].map { textureAtlas.textureNamed($0) }
            let animate = SKAction.animate(with: frames, timePerFrame: 0.2)
            //let forever = SKAction.repeatForever(animate)
            //self.run(forever)
            self.run(animate)
        }*/
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
