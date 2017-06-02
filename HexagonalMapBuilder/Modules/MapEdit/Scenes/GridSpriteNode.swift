//
//  GridSpriteNode.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 02.06.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import SpriteKit

class GridSpriteNode: SKSpriteNode {
    
    static let zLevel: CGFloat = 30.0
    
    init(withPosition position: CGPoint) {
        let texture = SKTexture(imageNamed: "Grid")
        super.init(texture: texture, color: NSColor.clear, size: texture.size())
        
        self.position = position
        self.anchorPoint = CGPoint(x: 0, y: 0)
        self.zPosition = GridSpriteNode.zLevel
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
