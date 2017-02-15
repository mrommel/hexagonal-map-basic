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
    
    // tile matching
    case matchesAny
    case matchesGround
    case matchesWater
    
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

class TerrainTransitionManager {
    
    class TerrainTransitionRule {
        
        let tileRule: Terrain
        let remoteRule: Terrain
        let directionRule: GridPointDirection
        let image: String
        
        required init(tileRule: Terrain, remoteRule: Terrain, directionRule: GridPointDirection, image: String) {
            
            self.tileRule = tileRule
            self.remoteRule = remoteRule
            self.directionRule = directionRule
            self.image = image
        }
        
        func matches(forCenter tileTerrain: Terrain, remote: Terrain, in direction: GridPointDirection) -> Bool {
            
            var isTerrain = false
            var isRemote = false
            var isDirection = false
            
            // tile matching
            if self.tileRule == .matchesWater && (tileTerrain == .ocean || tileTerrain == .shore) {
                isTerrain = true
            }
            
            if self.tileRule == .matchesGround && (tileTerrain != .ocean && tileTerrain != .shore) {
                isTerrain = true
            }
            
            if self.tileRule == tileTerrain {
                isTerrain = true
            }
            
            // remote matching
            if self.remoteRule == .matchesWater && (remote == .ocean || remote == .shore) {
                isRemote = true
            }
            
            if self.remoteRule == .matchesGround && (remote != .ocean && remote != .shore) {
                isRemote = true
            }
            
            if self.remoteRule == remote {
                isRemote = true
            }
            
            // direction matching
            if self.directionRule == direction {
                isDirection = true
            }
            
            return isTerrain && isRemote && isDirection
        }
    }
    
    var transitions: [TerrainTransitionRule]
    
    required init() {
        self.transitions = []
        
        self.transitions.append(TerrainTransitionRule(tileRule: .matchesGround, remoteRule: .matchesWater, directionRule: .northEast, image: "Ocean-se"))
        self.transitions.append(TerrainTransitionRule(tileRule: .matchesGround, remoteRule: .matchesWater, directionRule: .southEast, image: "Ocean-ne"))
        self.transitions.append(TerrainTransitionRule(tileRule: .matchesGround, remoteRule: .matchesWater, directionRule: .south, image: "Ocean-n"))
        self.transitions.append(TerrainTransitionRule(tileRule: .matchesGround, remoteRule: .matchesWater, directionRule: .southWest, image: "Ocean-nw"))
        self.transitions.append(TerrainTransitionRule(tileRule: .matchesGround, remoteRule: .matchesWater, directionRule: .northWest, image: "Ocean-sw"))
        self.transitions.append(TerrainTransitionRule(tileRule: .matchesGround, remoteRule: .matchesWater, directionRule: .north, image: "Ocean-s"))
        
    }
    
    func bestTransition(forCenter tileTerrain: Terrain, remote: Terrain, in direction: GridPointDirection) -> String? {
        
        for transitionRule in self.transitions {
            if transitionRule.matches(forCenter: tileTerrain, remote: remote, in: direction) {
                return transitionRule.image
            }
        }
        
        return nil
    }
}
