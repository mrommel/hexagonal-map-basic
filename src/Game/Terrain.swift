//
//  Terrain.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 09.02.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation

enum Terrain {
    
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
    
    // map generation
    case water
    case ground
    
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
        default:
            return "---"
        }
    }
}
