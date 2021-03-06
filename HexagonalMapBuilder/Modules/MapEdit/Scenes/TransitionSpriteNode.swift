//
//  File.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 02.06.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import SpriteKit
import HexagonalMapKit

class TransitionSpriteNode: SKSpriteNode {
    
    init(withPosition position: CGPoint, andTransition transition: TerrainTransitionManager.TerrainTransitionRule) {
        
        let texture = SKTexture(imageNamed: transition.image)
        super.init(texture: texture, color: NSColor.clear, size: texture.size())
        
        self.position = position
        self.anchorPoint = CGPoint(x: 0, y: 0)
        self.zPosition = CGFloat(transition.zLevel)
    }
    
    init(withPosition position: CGPoint, andTransition transition: FeatureTransitionManager.FeatureTransitionRule) {
        
        let texture = SKTexture(imageNamed: transition.image)
        super.init(texture: texture, color: NSColor.clear, size: texture.size())
        
        self.position = position
        self.anchorPoint = CGPoint(x: 0, y: 0)
        self.zPosition = CGFloat(transition.zLevel)
    }
    
    init(withPosition position: CGPoint, andTransition transition: RiverTransitionManager.RiverTransitionRule) {
        
        let texture = SKTexture(imageNamed: transition.image)
        super.init(texture: texture, color: NSColor.clear, size: texture.size())
        
        self.position = position
        self.anchorPoint = CGPoint(x: 0, y: 0)
        self.zPosition = CGFloat(55)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
