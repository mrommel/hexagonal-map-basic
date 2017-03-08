//
//  FeatureTransitionManager.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 02.03.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation

class FeatureTransitionManager {
    
    class FeatureTransitionRule {
        
        let tileRule: Feature?
        
        let remoteNE: Feature?
        let remoteSE: Feature?
        let remoteS: Feature?
        let remoteSW: Feature?
        let remoteNW: Feature?
        let remoteN: Feature?
        
        let image: String
        let zLevel: Int
        
        required init(tileRule: Feature?, remoteRule: String, image: String, zLevel: Int) {
            
            self.tileRule = tileRule
            
            let patterns = remoteRule.characters.split{$0 == ","}.map(String.init)
            
            remoteNE = Feature(rawValue: patterns[0])
            remoteSE = Feature(rawValue: patterns[1])
            remoteS = Feature(rawValue: patterns[2])
            remoteSW = Feature(rawValue: patterns[3])
            remoteNW = Feature(rawValue: patterns[4])
            remoteN = Feature(rawValue: patterns[5])
            
            self.image = image
            self.zLevel = zLevel
        }
        
        convenience init(tileRule: String, remoteRule: String, image: String, zLevel: Int) {
            
            self.init(tileRule: Feature(rawValue: tileRule), remoteRule: remoteRule, image: image, zLevel: zLevel)
        }
        
        static func matches(featureRule: Feature, andFeatures features: [Feature]) -> Int {
            
            if featureRule == .matchesAny {
                return 1
            }
            
            if featureRule == .matchesNoHill {
                var hasHill = false
                for feature in features {
                    if feature == .hill {
                        hasHill = true
                    }
                }
                
                return hasHill ? 0 : 2
            }

            for feature in features {
                
                if featureRule == feature {
                    return 3
                }
            }
            
            return 0
        }
        
        func matches(forCenter tileFeatures: [Feature], remotesNE: [Feature], remotesSE: [Feature], remotesS: [Feature], remotesSW: [Feature], remotesNW: [Feature], remotesN: [Feature]) -> Int {
            
            var score: Int = 0
            
            // tile matching
            if FeatureTransitionRule.matches(featureRule: self.tileRule!, andFeatures: tileFeatures) == 0 {
                return 0
            }
            
            // remote matching
            var tmpScore = 0
            tmpScore = FeatureTransitionRule.matches(featureRule: self.remoteNE!, andFeatures: remotesNE)
            guard tmpScore > 0 else {
                return 0
            }
            score += tmpScore
            
            tmpScore = FeatureTransitionRule.matches(featureRule: self.remoteSE!, andFeatures: remotesSE)
            guard tmpScore > 0 else {
                return 0
            }
            score += tmpScore
            
            tmpScore = FeatureTransitionRule.matches(featureRule: self.remoteS!, andFeatures: remotesS)
            guard tmpScore > 0 else {
                return 0
            }
            score += tmpScore
            
            tmpScore = FeatureTransitionRule.matches(featureRule: self.remoteSW!, andFeatures: remotesSW)
            guard tmpScore > 0 else {
                return 0
            }
            score += tmpScore
            
            tmpScore = FeatureTransitionRule.matches(featureRule: self.remoteNW!, andFeatures: remotesNW)
            guard tmpScore > 0 else {
                return 0
            }
            score += tmpScore
            
            tmpScore = FeatureTransitionRule.matches(featureRule: self.remoteN!, andFeatures: remotesN)
            guard tmpScore > 0 else {
                return 0
            }
            score += tmpScore
            
            return score
        }
    }
    
    var transitions: [FeatureTransitionRule]
    
    required init() {
        self.transitions = []
        
        // hill
        // 1 edge
        self.transitions.append(FeatureTransitionRule(tileRule: .matchesNoHill, remoteRule: "h,*,*,*,*,*", image: "Hill-se", zLevel: 24))
        self.transitions.append(FeatureTransitionRule(tileRule: .matchesNoHill, remoteRule: "*,h,*,*,*,*", image: "Hill-ne", zLevel: 24))
        self.transitions.append(FeatureTransitionRule(tileRule: .matchesNoHill, remoteRule: "*,*,h,*,*,*", image: "Hill-n", zLevel: 24))
        self.transitions.append(FeatureTransitionRule(tileRule: .matchesNoHill, remoteRule: "*,*,*,h,*,*", image: "Hill-nw", zLevel: 24))
        self.transitions.append(FeatureTransitionRule(tileRule: .matchesNoHill, remoteRule: "*,*,*,*,h,*", image: "Hill-sw", zLevel: 24))
        self.transitions.append(FeatureTransitionRule(tileRule: .matchesNoHill, remoteRule: "*,*,*,*,*,h", image: "Hill-s", zLevel: 24))
        
        // 2 edges
        self.transitions.append(FeatureTransitionRule(tileRule: .matchesNoHill, remoteRule: "*,h,h,*,*,*", image: "Hill-n-ne", zLevel: 24))
        self.transitions.append(FeatureTransitionRule(tileRule: .matchesNoHill, remoteRule: "*,*,*,*,h,h", image: "Hill-s-sw", zLevel: 24))
    }
    
    func bestTransitions(forCenter tileFeatures: [Feature], remotesNE: [Feature], remotesSE: [Feature], remotesS: [Feature], remotesSW: [Feature], remotesNW: [Feature], remotesN: [Feature]) -> [FeatureTransitionRule]? {
        
        var transitionImages: [FeatureTransitionRule]? = []
        
        for transitionRule in self.transitions {
            
            let currentScore = transitionRule.matches(forCenter: tileFeatures, remotesNE: remotesNE, remotesSE: remotesSE, remotesS: remotesS, remotesSW: remotesSW, remotesNW: remotesNW, remotesN: remotesN)
            
            if currentScore > 0 {
                transitionImages?.append(transitionRule)
            }
        }
        
        return transitionImages
    }
}
