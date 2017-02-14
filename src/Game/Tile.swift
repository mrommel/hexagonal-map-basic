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
}
