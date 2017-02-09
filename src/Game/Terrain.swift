//
//  Terrain.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 09.02.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation

enum TerrainType {
    case ocean
    case shore
    case grass
    
    var image: String {
        switch self {
        case .ocean:
            return "Ocean"
        case .shore:
            return "Shore"
        case .grass:
            return "Grassland"
        }
    }
}

class Terrain: NSObject {
    
    static let `default` = Terrain(terrainType: .ocean)
    
    let terrainType: TerrainType
    
    required init(terrainType: TerrainType) {
        self.terrainType = terrainType
    }
}
