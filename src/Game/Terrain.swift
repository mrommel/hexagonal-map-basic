//
//  Terrain.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 09.02.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation

enum Terrain: String {
    
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
    
    var isWater: Bool {
        switch self {
        case .ocean:
            return true
        case .shore:
            return true
        default:
            return false
        }

    }
    
    var isGround: Bool {
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
}

class TerrainTransitionManager {
    
    class TerrainTransitionRule {
        
        let tileRule: Terrain?
        
        let remoteNE: Terrain?
        let remoteSE: Terrain?
        let remoteS: Terrain?
        let remoteSW: Terrain?
        let remoteNW: Terrain?
        let remoteN: Terrain?
        
        let image: String
        
        required init(tileRule: Terrain?, remoteRule: String, image: String) {
            
            self.tileRule = tileRule
            
            let patterns = remoteRule.characters.split{$0 == ","}.map(String.init)
            
            remoteNE = Terrain(rawValue: patterns[0])
            remoteSE = Terrain(rawValue: patterns[1])
            remoteS = Terrain(rawValue: patterns[2])
            remoteSW = Terrain(rawValue: patterns[3])
            remoteNW = Terrain(rawValue: patterns[4])
            remoteN = Terrain(rawValue: patterns[5])
            
            self.image = image
        }
        
        static func matches(terrainRule: Terrain, andTerrain terrain: Terrain) -> Int {

            if terrainRule == terrain {
                return 3
            }
            
            if terrainRule == .matchesGround && terrain.isGround {
                return 2
            }
            
            if terrainRule == .matchesWater && terrain.isWater {
                return 2
            }
            
            if terrainRule == .matchesAny {
                return 1
            }
            
            return 0
        }
        
        func matches(forCenter tileTerrain: Terrain, remoteNE: Terrain, remoteSE: Terrain, remoteS: Terrain, remoteSW: Terrain, remoteNW: Terrain, remoteN: Terrain) -> Int {
            
            var score: Int = 0
            
            // tile matching
            if TerrainTransitionRule.matches(terrainRule: self.tileRule!, andTerrain: tileTerrain) == 0 {
                return 0
            }
            
            // remote matching
            var tmpScore = 0
            tmpScore = TerrainTransitionRule.matches(terrainRule: self.remoteNE!, andTerrain: remoteNE)
            if tmpScore == 0 {
                return 0
            } else {
                score += tmpScore
            }
            
            tmpScore = TerrainTransitionRule.matches(terrainRule: self.remoteSE!, andTerrain: remoteSE)
            if tmpScore == 0 {
                return 0
            } else {
                score += tmpScore
            }
            
            tmpScore = TerrainTransitionRule.matches(terrainRule: self.remoteS!, andTerrain: remoteS)
            if tmpScore == 0 {
                return 0
            } else {
                score += tmpScore
            }
            
            tmpScore = TerrainTransitionRule.matches(terrainRule: self.remoteSW!, andTerrain: remoteSW)
            if tmpScore == 0 {
                return 0
            } else {
                score += tmpScore
            }
            
            tmpScore = TerrainTransitionRule.matches(terrainRule: self.remoteNW!, andTerrain: remoteNW)
            if tmpScore == 0 {
                return 0
            } else {
                score += tmpScore
            }
            
            tmpScore = TerrainTransitionRule.matches(terrainRule: self.remoteN!, andTerrain: remoteN)
            if tmpScore == 0 {
                return 0
            } else {
                score += tmpScore
            }
            
            return score
        }
    }
    
    var transitions: [TerrainTransitionRule]
    
    required init() {
        self.transitions = []
        
        // beach
        self.transitions.append(TerrainTransitionRule(tileRule: .matchesWater, remoteRule: "-,~,*,*,*,~", image: "Beach-se"))
        self.transitions.append(TerrainTransitionRule(tileRule: .matchesWater, remoteRule: "~,-,~,*,*,*", image: "Beach-ne"))
        self.transitions.append(TerrainTransitionRule(tileRule: .matchesWater, remoteRule: "*,~,-,~,*,*", image: "Beach-n"))
        self.transitions.append(TerrainTransitionRule(tileRule: .matchesWater, remoteRule: "*,*,~,-,~,*", image: "Beach-nw"))
        self.transitions.append(TerrainTransitionRule(tileRule: .matchesWater, remoteRule: "*,*,*,~,-,~", image: "Beach-sw"))
        self.transitions.append(TerrainTransitionRule(tileRule: .matchesWater, remoteRule: "~,*,*,*,~,-", image: "Beach-s"))

        self.transitions.append(TerrainTransitionRule(tileRule: .matchesWater, remoteRule: "-,-,~,*,*,~", image: "Beach-ne-se"))
        self.transitions.append(TerrainTransitionRule(tileRule: .matchesWater, remoteRule: "~,-,-,~,*,*", image: "Beach-n-ne"))
        
    }
    
    func bestTransition(forCenter tileTerrain: Terrain, remoteNE: Terrain, remoteSE: Terrain, remoteS: Terrain, remoteSW: Terrain, remoteNW: Terrain, remoteN: Terrain) -> String? {
        
        var bestRule: TerrainTransitionRule? = nil
        var bestScore: Int = 0
        
        for transitionRule in self.transitions {
            
            let currentScore = transitionRule.matches(forCenter: tileTerrain, remoteNE: remoteNE, remoteSE: remoteSE, remoteS: remoteS, remoteSW: remoteSW, remoteNW: remoteNW,remoteN: remoteN)
            
            if currentScore > bestScore {
                bestScore = currentScore
                bestRule = transitionRule
            }
        }
        
        if bestRule != nil {
            return bestRule?.image
        }
        
        return nil
    }
}
