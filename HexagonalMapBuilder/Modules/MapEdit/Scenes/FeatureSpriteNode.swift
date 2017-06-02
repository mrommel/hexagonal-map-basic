//
//  FeatureSpriteNode.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 02.06.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import SpriteKit
import HexagonalMapKit

class FeatureSpriteNode: SKSpriteNode {
    
    static let zLevel: CGFloat = 50.0
    
    init(withPosition position: CGPoint, andFeature feature: Feature) {
        let texture = SKTexture(imageNamed: feature.image)
        super.init(texture: texture, color: NSColor.clear, size: texture.size())
        
        self.position = position
        self.anchorPoint = CGPoint(x: 0, y: 0)
        self.zPosition = FeatureSpriteNode.zLevel
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
