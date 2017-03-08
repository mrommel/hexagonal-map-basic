//
//  RiverTransitionManager.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 08.03.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation

class RiverTransitionManager {
    
    /**
        +----+
       / ====\\
      /       \\
     +        + +
      \      / /
       \    / /
        +----+
     
     */
    class RiverTransitionRule {
        
        let tileRule: FlowDirection?
        
        let remoteNE: FlowDirection?
        let remoteSE: FlowDirection?
        let remoteS: FlowDirection?
        let remoteSW: FlowDirection?
        let remoteNW: FlowDirection?
        let remoteN: FlowDirection?
        
        let image: String //
        
        required init(tileRule: String, remoteRule: String, image: String) {
            
            self.tileRule = FlowDirection(rawValue: tileRule)
            
            let patterns = remoteRule.characters.split{$0 == ","}.map(String.init)
            
            remoteNE = FlowDirection(rawValue: patterns[0])
            remoteSE = FlowDirection(rawValue: patterns[1])
            remoteS = FlowDirection(rawValue: patterns[2])
            remoteSW = FlowDirection(rawValue: patterns[3])
            remoteNW = FlowDirection(rawValue: patterns[4])
            remoteN = FlowDirection(rawValue: patterns[5])
            
            self.image = image
        }
        
        func matches(forCenter tileFlow: FlowDirection, flowNE: FlowDirection, flowSE: FlowDirection, flowS: FlowDirection, flowSW: FlowDirection, flowNW: FlowDirection, flowN: FlowDirection) -> Bool {
            
            var match = self.tileRule == tileFlow || self.tileRule == .any
            
            match = match && (self.remoteNE == flowNE || self.remoteNE == .any)
            match = match && (self.remoteSE == flowSE || self.remoteSE == .any)
            match = match && (self.remoteS == flowS || self.remoteS == .any)
            match = match && (self.remoteSW == flowSW || self.remoteSW == .any)
            match = match && (self.remoteNW == flowNW || self.remoteNW == .any)
            match = match && (self.remoteN == flowN || self.remoteN == .any)
            
            return match
        }

    }
    
    var transitions: [RiverTransitionRule]
    
    required init() {
        self.transitions = []
        
        // river
        // flowing in north (flowing east or west)
        self.transitions.append(RiverTransitionRule(tileRule: "e", remoteRule: "h,*,*,*,*,*", image: "River-n-"))
    }
    
    func bestTransitions(forCenter tileFlows: [FlowDirection], remotesNE: [FlowDirection], remotesSE: [FlowDirection], remotesS: [FlowDirection], remotesSW: [FlowDirection], remotesNW: [FlowDirection], remotesN: [FlowDirection]) -> [RiverTransitionRule]? {
        
        var transitionRules: [RiverTransitionRule]? = []
        
        for tileFlow in tileFlows {
            transitionRules?.append(contentsOf: self.bestTransition(forCenter: tileFlow, remotesNE: remotesNE, remotesSE: remotesSE, remotesS: remotesS, remotesSW: remotesSW, remotesNW: remotesNW, remotesN: remotesN)!)
        }
        
        return transitionRules
    }
    
    func bestTransition(forCenter tileFlow: FlowDirection, remotesNE: [FlowDirection], remotesSE: [FlowDirection], remotesS: [FlowDirection], remotesSW: [FlowDirection], remotesNW: [FlowDirection], remotesN: [FlowDirection]) -> [RiverTransitionRule]? {
        
        var transitionRules: [RiverTransitionRule]? = []
        
        for remoteNE in remotesNE {
            transitionRules?.append(contentsOf: self.bestTransition(forCenter: tileFlow, remoteNE: remoteNE, remotesSE: remotesSE, remotesS: remotesS, remotesSW: remotesSW, remotesNW: remotesNW, remotesN: remotesN)!)
        }
        
        return transitionRules
    }
    
    func bestTransition(forCenter tileFlow: FlowDirection, remoteNE: FlowDirection, remotesSE: [FlowDirection], remotesS: [FlowDirection], remotesSW: [FlowDirection], remotesNW: [FlowDirection], remotesN: [FlowDirection]) -> [RiverTransitionRule]? {
        
        var transitionRules: [RiverTransitionRule]? = []
        
        for remoteSE in remotesSE {
            transitionRules?.append(contentsOf: self.bestTransition(forCenter: tileFlow, remoteNE: remoteNE, remoteSE: remoteSE, remotesS: remotesS, remotesSW: remotesSW, remotesNW: remotesNW, remotesN: remotesN)!)
        }
        
        return transitionRules
    }
    
    // ...
    
    func bestTransition(forCenter tileFlow: FlowDirection, remoteNE: FlowDirection, remoteSE: FlowDirection, remoteS: FlowDirection, remoteSW: FlowDirection, remoteNW: FlowDirection, remoteN: FlowDirection) -> [RiverTransitionRule]? {
        
        var transitionRules: [RiverTransitionRule]? = []
        
        for transitionRule in self.transitions {
                
            let matches = transitionRule.matches(forCenter: tileFlow, flowNE: remoteNE, flowSE: remoteSE, flowS: remoteS, flowSW: remoteSW, flowNW: remoteNW, flowN: remoteN)
            
            if matches {
                transitionRules?.append(transitionRule)
            }
        }
        
        return transitionRules
    }
    
}
