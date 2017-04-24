//
//  TerrainTransitionManager.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 16.02.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation
import HexagonalMap

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
        let zLevel: Int
        
        required init(tileRule: Terrain?, remoteRule: String, image: String, zLevel: Int) {
            
            self.tileRule = tileRule
            
            let patterns = remoteRule.characters.split {$0 == ","}.map(String.init)
            
            remoteNE = Terrain(rawValue: patterns[0])
            remoteSE = Terrain(rawValue: patterns[1])
            remoteS = Terrain(rawValue: patterns[2])
            remoteSW = Terrain(rawValue: patterns[3])
            remoteNW = Terrain(rawValue: patterns[4])
            remoteN = Terrain(rawValue: patterns[5])
            
            self.image = image
            self.zLevel = zLevel
        }
        
        convenience init(tileRule: String, remoteRule: String, image: String, zLevel: Int) {
            
            self.init(tileRule: Terrain(rawValue: tileRule), remoteRule: remoteRule, image: image, zLevel: zLevel)
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
            guard tmpScore > 0 else {
                return 0
            }
            score += tmpScore
            
            tmpScore = TerrainTransitionRule.matches(terrainRule: self.remoteSE!, andTerrain: remoteSE)
            guard tmpScore > 0 else {
                return 0
            }
            score += tmpScore
            
            tmpScore = TerrainTransitionRule.matches(terrainRule: self.remoteS!, andTerrain: remoteS)
            guard tmpScore > 0 else {
                return 0
            }
            score += tmpScore
            
            tmpScore = TerrainTransitionRule.matches(terrainRule: self.remoteSW!, andTerrain: remoteSW)
            guard tmpScore > 0 else {
                return 0
            }
            score += tmpScore
            
            tmpScore = TerrainTransitionRule.matches(terrainRule: self.remoteNW!, andTerrain: remoteNW)
            guard tmpScore > 0 else {
                return 0
            }
            score += tmpScore
            
            tmpScore = TerrainTransitionRule.matches(terrainRule: self.remoteN!, andTerrain: remoteN)
            guard tmpScore > 0 else {
                return 0
            }
            score += tmpScore
            
            return score
        }
    }
    
    var transitions: [TerrainTransitionRule]
    
    required init() {
        self.transitions = []
        
        // beach
        // 1 edge
        self.transitions.append(TerrainTransitionRule(tileRule: .matchesWater, remoteRule: "-,~,*,*,*,~", image: "Beach-ne", zLevel: 21))
        self.transitions.append(TerrainTransitionRule(tileRule: .matchesWater, remoteRule: "~,-,~,*,*,*", image: "Beach-se", zLevel: 21))
        self.transitions.append(TerrainTransitionRule(tileRule: .matchesWater, remoteRule: "*,~,-,~,*,*", image: "Beach-s", zLevel: 21))
        self.transitions.append(TerrainTransitionRule(tileRule: .matchesWater, remoteRule: "*,*,~,-,~,*", image: "Beach-sw", zLevel: 21))
        self.transitions.append(TerrainTransitionRule(tileRule: .matchesWater, remoteRule: "*,*,*,~,-,~", image: "Beach-nw", zLevel: 21))
        self.transitions.append(TerrainTransitionRule(tileRule: .matchesWater, remoteRule: "~,*,*,*,~,-", image: "Beach-n", zLevel: 21))
        
        // 2 edges
        self.transitions.append(TerrainTransitionRule(tileRule: .matchesWater, remoteRule: "-,-,~,*,*,~", image: "Beach-ne-se", zLevel: 21))
        self.transitions.append(TerrainTransitionRule(tileRule: .matchesWater, remoteRule: "~,-,-,~,*,*", image: "Beach-se-s", zLevel: 21))
        self.transitions.append(TerrainTransitionRule(tileRule: .matchesWater, remoteRule: "*,~,-,-,~,*", image: "Beach-s-sw", zLevel: 21))
        self.transitions.append(TerrainTransitionRule(tileRule: .matchesWater, remoteRule: "*,*,~,-,-,~", image: "Beach-sw-nw", zLevel: 21))
        self.transitions.append(TerrainTransitionRule(tileRule: .matchesWater, remoteRule: "~,*,*,~,-,-", image: "Beach-nw-n", zLevel: 21))
        self.transitions.append(TerrainTransitionRule(tileRule: .matchesWater, remoteRule: "-,~,*,*,~,-", image: "Beach-n-ne", zLevel: 21))
        
        // 3 edges
        self.transitions.append(TerrainTransitionRule(tileRule: .matchesWater, remoteRule: "-,-,-,~,*,~", image: "Beach-ne-se-s", zLevel: 21))
        self.transitions.append(TerrainTransitionRule(tileRule: .matchesWater, remoteRule: "~,-,-,-,~,*", image: "Beach-se-s-sw", zLevel: 21))
        self.transitions.append(TerrainTransitionRule(tileRule: .matchesWater, remoteRule: "*,~,-,-,-,~", image: "Beach-s-sw-nw", zLevel: 21))
        self.transitions.append(TerrainTransitionRule(tileRule: .matchesWater, remoteRule: "~,*,~,-,-,-", image: "Beach-sw-nw-n", zLevel: 21))
        self.transitions.append(TerrainTransitionRule(tileRule: .matchesWater, remoteRule: "-,~,*,~,-,-", image: "Beach-nw-n-ne", zLevel: 21))
        self.transitions.append(TerrainTransitionRule(tileRule: .matchesWater, remoteRule: "-,-,~,*,~,-", image: "Beach-n-ne-se", zLevel: 21))
        
        // 4 edges
        self.transitions.append(TerrainTransitionRule(tileRule: .matchesWater, remoteRule: "-,-,-,~,~,-", image: "Beach-n-ne-se-s", zLevel: 21))
        self.transitions.append(TerrainTransitionRule(tileRule: .matchesWater, remoteRule: "-,-,-,-,~,~", image: "Beach-ne-se-s-sw", zLevel: 21))
        self.transitions.append(TerrainTransitionRule(tileRule: .matchesWater, remoteRule: "~,-,-,-,-,~", image: "Beach-se-s-sw-nw", zLevel: 21))
        self.transitions.append(TerrainTransitionRule(tileRule: .matchesWater, remoteRule: "~,~,-,-,-,-", image: "Beach-s-sw-nw-n", zLevel: 21))
        self.transitions.append(TerrainTransitionRule(tileRule: .matchesWater, remoteRule: "-,~,~,-,-,-", image: "Beach-sw-nw-n-ne", zLevel: 21))
        self.transitions.append(TerrainTransitionRule(tileRule: .matchesWater, remoteRule: "-,-,~,~,-,-", image: "Beach-nw-n-ne-se", zLevel: 21))
        
        // 5 edges
        self.transitions.append(TerrainTransitionRule(tileRule: .matchesWater, remoteRule: "-,-,-,~,-,-", image: "Beach-nw-n-ne-se-s", zLevel: 21))
        self.transitions.append(TerrainTransitionRule(tileRule: .matchesWater, remoteRule: "-,-,-,-,~,-", image: "Beach-n-ne-se-s-sw", zLevel: 21))
        self.transitions.append(TerrainTransitionRule(tileRule: .matchesWater, remoteRule: "-,-,-,-,-,~", image: "Beach-ne-se-s-sw-nw", zLevel: 21))
        self.transitions.append(TerrainTransitionRule(tileRule: .matchesWater, remoteRule: "~,-,-,-,-,-", image: "Beach-se-s-sw-nw-n", zLevel: 21))
        self.transitions.append(TerrainTransitionRule(tileRule: .matchesWater, remoteRule: "-,~,-,-,-,-", image: "Beach-s-sw-nw-n-ne", zLevel: 21))
        self.transitions.append(TerrainTransitionRule(tileRule: .matchesWater, remoteRule: "-,-,~,-,-,-", image: "Beach-sw-nw-n-ne-se", zLevel: 21))
        
        // all 6 edges
        self.transitions.append(TerrainTransitionRule(tileRule: .matchesWater, remoteRule: "-,-,-,-,-,-", image: "Beach-n-ne-se-s-sw-nw", zLevel: 21))
        
        // grass
        self.transitions.append(TerrainTransitionRule(tileRule: .matchesWater, remoteRule: "gs,*,*,*,*,*", image: "Grassland-ne", zLevel: 22))
        self.transitions.append(TerrainTransitionRule(tileRule: .matchesWater, remoteRule: "*,gs,*,*,*,*", image: "Grassland-se", zLevel: 22))
        self.transitions.append(TerrainTransitionRule(tileRule: .matchesWater, remoteRule: "*,*,gs,*,*,*", image: "Grassland-s", zLevel: 22))
        self.transitions.append(TerrainTransitionRule(tileRule: .matchesWater, remoteRule: "*,*,*,gs,*,*", image: "Grassland-sw", zLevel: 22))
        self.transitions.append(TerrainTransitionRule(tileRule: .matchesWater, remoteRule: "*,*,*,*,gs,*", image: "Grassland-nw", zLevel: 22))
        self.transitions.append(TerrainTransitionRule(tileRule: .matchesWater, remoteRule: "*,*,*,*,*,gs", image: "Grassland-n", zLevel: 22))
        
    }
    
    func bestTransitions(forCenter tileTerrain: Terrain, remotePattern: String) -> [TerrainTransitionRule]? {
        
        let patterns = remotePattern.characters.split {$0 == ","}.map(String.init)
        
        let remNE = Terrain(rawValue: patterns[0])
        let remSE = Terrain(rawValue: patterns[1])
        let remS = Terrain(rawValue: patterns[2])
        let remSW = Terrain(rawValue: patterns[3])
        let remNW = Terrain(rawValue: patterns[4])
        let remN = Terrain(rawValue: patterns[5])
        
        return self.bestTransitions(forCenter: tileTerrain, remoteNE: remNE!, remoteSE: remSE!, remoteS: remS!, remoteSW: remSW!, remoteNW: remNW!, remoteN: remN!)
    }
    
    func bestTransitions(forCenter tileTerrain: Terrain, remoteNE: Terrain, remoteSE: Terrain, remoteS: Terrain, remoteSW: Terrain, remoteNW: Terrain, remoteN: Terrain) -> [TerrainTransitionRule]? {
        
        var transitionImages: [TerrainTransitionRule]? = []
        
        for transitionRule in self.transitions {
            
            let currentScore = transitionRule.matches(forCenter: tileTerrain, remoteNE: remoteNE, remoteSE: remoteSE, remoteS: remoteS, remoteSW: remoteSW, remoteNW: remoteNW,remoteN: remoteN)
            
            if currentScore > 0 {
                transitionImages?.append(transitionRule)
            }
        }
        
        return transitionImages
    }
}
