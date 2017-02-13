//
//  Terrain.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 09.02.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation

enum TerrainType {
    
    // misc
    case outside
    
    // water terrain
    case ocean
    case shore
    
    // solid terrain
    case grass
    case plains
    case desert
    case tundra
    case snow
    
    var image: String {
        switch self {
        case .outside:
            return "Outside"
        case .ocean:
            return "Ocean"
        case .shore:
            return "Shore"
        case .grass:
            return "Grassland"
        case .plains:
            return "Plains"
        case .desert:
            return "Desert"
        case .tundra:
            return "Tundra"
        case .snow:
            return "Snow"
        }
    }
}

class Terrain: NSObject {
    
    static let `default` = Terrain(terrainType: .ocean)
    static let outside = Terrain(terrainType: .outside)
    
    let terrainType: TerrainType
    
    required init(terrainType: TerrainType) {
        self.terrainType = terrainType
    }
}
