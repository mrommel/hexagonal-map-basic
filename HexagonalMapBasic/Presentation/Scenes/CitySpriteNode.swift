//
//  CitySpriteNode.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 28.03.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import SpriteKit
import HexagonalMap

class CitySpriteNode: SKSpriteNode {
    
    static let zLevel: CGFloat = 60.0
    
    init(withPosition position: CGPoint, andCity city: City) {
        
        let texture = SKTexture(imageNamed: "City")
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        
        self.position = position
        self.anchorPoint = CGPoint(x: 0, y: 0)
        self.zPosition = CitySpriteNode.zLevel
    }
    
    required init(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}
