//
//  Tile.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 14.02.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation

class Tile: NSObject {
    
    var terrain: Terrain? = Terrain.ocean
    var features: [Feature] = []
    
    required init(withTerrain terrain: Terrain) {
        self.terrain = terrain
    }
    
    func has(feature: Feature) -> Bool {
        return false
    }
    
    var possibleImprovements: [TileImprovementType] {
        
        switch self.terrain! {
        case .shore:
            return [.fishing]
        case .grass:
            if self.has(feature: .forest) {
                return [.lumbermill]
            } else if self.has(feature: .hill) {
                return [.pasture]
            } else {
                return [.farm, .pasture]
            }
        default:
            return []
        }
    }
}
