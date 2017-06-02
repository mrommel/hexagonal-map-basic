//
//  RiverTransitionManager.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 08.03.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation

public class RiverTransitionManager {
    
    class RiverTransitionCondition {
        
        let isCenter: Bool // or
        var direction: GridPointDirection = GridPointDirection.north // if not isCenter
        
        let flow: FlowDirection
        
        required init(forFlow flow: FlowDirection) {
            
            self.isCenter = true
            self.flow = flow
        }
        
        required init(forDirection direction: GridPointDirection, withFlow flow: FlowDirection) {
            
            self.isCenter = false
            self.direction = direction
            self.flow = flow
        }
        
        func isIn(flows: [FlowDirection]) -> Bool {
            
            return flows.contains( where: { $0 == flow } )
        }
    }
    
    /**
        +--|--+
       / ==|==\\
      / \  |  /\\
     +     o   > +
      \ /  |  X /
       \   | / /
        +--|--+
     */
    public class RiverTransitionRule {
        
        let tileCondition: RiverTransitionCondition?
        let remoteCondition: RiverTransitionCondition?

        public let image: String //
        
        /**
            - Parameter tileRule: string representation of FlowDirection
            - Parameter remoteCondition: e.g. "GridPointDirection,FlowDirection"
         */
        public required init(tileRule: String, remoteCondition: String, image: String) {
            
            // current tile
            let tileFlow = FlowDirection(rawValue: tileRule)
            self.tileCondition = RiverTransitionCondition(forFlow: tileFlow!)
            
            // remote (or even current tile but different flow)
            let patterns = remoteCondition.characters.split {$0 == ","}.map(String.init)
            if patterns[0] == "#" {
                let secondTileFlow = FlowDirection(rawValue: patterns[1])
                self.remoteCondition = RiverTransitionCondition(forFlow: secondTileFlow!)
            } else {
                let remoteDirection = GridPointDirection(rawValue: patterns[0])
                let remoteFlow = FlowDirection(rawValue: patterns[1])
                self.remoteCondition = RiverTransitionCondition(forDirection: remoteDirection!, withFlow: remoteFlow!)
            }
            
            self.image = image
        }
        
        func matches(forCenter tileFlows: [FlowDirection], flowsNE: [FlowDirection], flowsSE: [FlowDirection], flowsS: [FlowDirection], flowsSW: [FlowDirection], flowsNW: [FlowDirection], flowsN: [FlowDirection]) -> Bool {
            
            // match tile condition
            if !(self.tileCondition?.isIn(flows: tileFlows))! {
                return false
            }
            
            if (self.remoteCondition?.isCenter)! {
                // in this case we need to check if current tile also contains the remote (=current) condition
                return (self.remoteCondition?.isIn(flows: tileFlows))!
            } else {
                switch (self.remoteCondition?.direction)! {
                case .northEast:
                    return (self.remoteCondition?.isIn(flows: flowsNE))!
                case .southEast:
                    return (self.remoteCondition?.isIn(flows: flowsSE))!
                case .south:
                    return (self.remoteCondition?.isIn(flows: flowsS))!
                case .southWest:
                    return (self.remoteCondition?.isIn(flows: flowsSW))!
                case .northWest:
                    return (self.remoteCondition?.isIn(flows: flowsNW))!
                case .north:
                    return (self.remoteCondition?.isIn(flows: flowsN))!
                }
            }
        }

    }
    
    var transitions: [RiverTransitionRule]
    
    required public init() {
        self.transitions = []
        
        // River-1
        self.transitions.append(RiverTransitionRule(tileRule: "e", remoteCondition: "#,nw", image: "River-1"))
        self.transitions.append(RiverTransitionRule(tileRule: "w", remoteCondition: "#,nw", image: "River-1"))
        self.transitions.append(RiverTransitionRule(tileRule: "e", remoteCondition: "#,se", image: "River-1"))
        self.transitions.append(RiverTransitionRule(tileRule: "w", remoteCondition: "#,se", image: "River-1"))
        
        // River-2
        self.transitions.append(RiverTransitionRule(tileRule: "e", remoteCondition: "nw,sw", image: "River-2"))
        self.transitions.append(RiverTransitionRule(tileRule: "w", remoteCondition: "nw,sw", image: "River-2"))
        self.transitions.append(RiverTransitionRule(tileRule: "e", remoteCondition: "nw,ne", image: "River-2"))
        self.transitions.append(RiverTransitionRule(tileRule: "w", remoteCondition: "nw,ne", image: "River-2"))
        
        // River-3
        self.transitions.append(RiverTransitionRule(tileRule: "e", remoteCondition: "nw,se", image: "River-3"))
        self.transitions.append(RiverTransitionRule(tileRule: "w", remoteCondition: "nw,se", image: "River-3"))
        self.transitions.append(RiverTransitionRule(tileRule: "e", remoteCondition: "nw,nw", image: "River-3"))
        self.transitions.append(RiverTransitionRule(tileRule: "w", remoteCondition: "nw,nw", image: "River-3"))
        
        // River-4
        self.transitions.append(RiverTransitionRule(tileRule: "e", remoteCondition: "n,sw", image: "River-4"))
        self.transitions.append(RiverTransitionRule(tileRule: "w", remoteCondition: "n,sw", image: "River-4"))
        self.transitions.append(RiverTransitionRule(tileRule: "e", remoteCondition: "n,ne", image: "River-4"))
        self.transitions.append(RiverTransitionRule(tileRule: "w", remoteCondition: "n,ne", image: "River-4"))
        
        // River-5
        self.transitions.append(RiverTransitionRule(tileRule: "nw", remoteCondition: "n,sw", image: "River-5"))
        self.transitions.append(RiverTransitionRule(tileRule: "se", remoteCondition: "n,sw", image: "River-5"))
        self.transitions.append(RiverTransitionRule(tileRule: "nw", remoteCondition: "n,ne", image: "River-5"))
        self.transitions.append(RiverTransitionRule(tileRule: "se", remoteCondition: "n,ne", image: "River-5"))
        
        // River-6
        self.transitions.append(RiverTransitionRule(tileRule: "nw", remoteCondition: "se,e", image: "River-6"))
        self.transitions.append(RiverTransitionRule(tileRule: "se", remoteCondition: "se,e", image: "River-6"))
        self.transitions.append(RiverTransitionRule(tileRule: "nw", remoteCondition: "se,w", image: "River-6"))
        self.transitions.append(RiverTransitionRule(tileRule: "se", remoteCondition: "se,w", image: "River-6"))
        
        // River-7
        self.transitions.append(RiverTransitionRule(tileRule: "nw", remoteCondition: "#,sw", image: "River-7"))
        self.transitions.append(RiverTransitionRule(tileRule: "se", remoteCondition: "#,sw", image: "River-7"))
        self.transitions.append(RiverTransitionRule(tileRule: "nw", remoteCondition: "#,ne", image: "River-7"))
        self.transitions.append(RiverTransitionRule(tileRule: "se", remoteCondition: "#,ne", image: "River-7"))
        
        // River-8
        self.transitions.append(RiverTransitionRule(tileRule: "sw", remoteCondition: "se,e", image: "River-8"))
        self.transitions.append(RiverTransitionRule(tileRule: "ne", remoteCondition: "se,e", image: "River-8"))
        self.transitions.append(RiverTransitionRule(tileRule: "sw", remoteCondition: "se,w", image: "River-8"))
        self.transitions.append(RiverTransitionRule(tileRule: "ne", remoteCondition: "se,w", image: "River-8"))
        
        // River-9
        self.transitions.append(RiverTransitionRule(tileRule: "sw", remoteCondition: "s,e", image: "River-9"))
        self.transitions.append(RiverTransitionRule(tileRule: "ne", remoteCondition: "s,e", image: "River-9"))
        self.transitions.append(RiverTransitionRule(tileRule: "sw", remoteCondition: "s,w", image: "River-9"))
        self.transitions.append(RiverTransitionRule(tileRule: "ne", remoteCondition: "s,w", image: "River-9"))
        
        // River-10
        self.transitions.append(RiverTransitionRule(tileRule: "sw", remoteCondition: "s,se", image: "River-10"))
        self.transitions.append(RiverTransitionRule(tileRule: "ne", remoteCondition: "s,se", image: "River-10"))
        self.transitions.append(RiverTransitionRule(tileRule: "sw", remoteCondition: "s,nw", image: "River-10"))
        self.transitions.append(RiverTransitionRule(tileRule: "ne", remoteCondition: "s,nw", image: "River-10"))
    }
    
    public func bestTransitions(forCenter tileFlows: [FlowDirection], remotesNE: [FlowDirection], remotesSE: [FlowDirection], remotesS: [FlowDirection], remotesSW: [FlowDirection], remotesNW: [FlowDirection], remotesN: [FlowDirection]) -> [RiverTransitionRule]? {
        
        var transitionRules: [RiverTransitionRule]? = []
        
        for transition in transitions {
            if transition.matches(forCenter: tileFlows, flowsNE: remotesNE, flowsSE: remotesSE, flowsS: remotesS, flowsSW: remotesSW, flowsNW: remotesNW, flowsN: remotesN) {
                transitionRules?.append(transition)
            }
        }
        
        return transitionRules
    }
}
