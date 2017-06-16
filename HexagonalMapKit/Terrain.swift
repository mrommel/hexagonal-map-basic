//
//  Terrain.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 09.02.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation
import JSONCodable

public enum Terrain: String {

    // misc
    case outside = "out"
    
    // water terrain
    case ocean = "oc"
    case shore = "sh"
    
    // solid terrain
    case grass = "gs"
    case plains = "pl"
    case desert = "ds"
    case tundra = "td"
    case snow = "sn"
    
    // map generation
    case water = "wt"
    case ground = "gr"
    
    // tile matching
    case matchesAny = "*"
    case matchesGround = "-"
    case matchesWater = "~"
    
    public static func enumFrom(string: String) -> Terrain? {
        switch string {
        case "ocean":
            return .ocean
        case "shore":
            return .shore
        case "grass":
            return .grass
        case "grassland":
            return .grass
        case "plains":
            return .plains
        case "desert":
            return .desert
        case "tundra":
            return .tundra
        case "snow":
            return .snow

        default:
            print("--> Terrain.enumFromString \(string) not handled")
            return .outside
        }
    }
    
    public var stringValue: String {
        switch self {
        case .outside:
            return "outside"
        case .ocean:
            return "ocean"
        case .shore:
            return "shore"
        case .grass:
            return "grass"
        case .plains:
            return "plains"
        case .desert:
            return "desert"
        case .tundra:
            return "tundra"
        case .snow:
            return "snow"
        default:
            print("no string for terrain: \(self)")
            return "---"
        }
    }
    
    public var image: String {
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
            print("no image for terrain: \(self)")
            return "---"
        }
    }
    
    public var name: String {
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
            print("no name for terrain: \(self)")
            return "---"
        }
    }
    
    public var isWater: Bool {
        switch self {
        case .outside:
            return true
        case .ocean:
            return true
        case .shore:
            return true
        default:
            return false
        }
    }
    
    public var isGround: Bool {
        switch self {
        case .grass:
            return true
        case .plains:
            return true
        case .desert:
            return true
        case .tundra:
            return true
        case .snow:
            return true
        default:
            return false
        }
    }
    
    /**
    method that returns, if it is allowed to found a city here (for grass, plains, tundra) / false otherwise
     */
    public var canFoundCity: Bool {
        switch self {
        case .grass:
            return true
        case .plains:
            return true
        case .tundra:
            return true
        default:
            return false
        }
    }
}
