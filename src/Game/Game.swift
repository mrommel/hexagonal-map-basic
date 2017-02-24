//
//  Game.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 22.02.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation

class VictoryCondition {

    let name: String

    required init(withName name: String) {
        self.name = name
    }
}

class PlayerStatistics {
    
}

class GameStatistics {
    
    // stats by player
    var discoveredTiles: Int = 0
    
}

class Game {

    let name: String
    let text: String

    var map: Map? = nil
    var conditions: [VictoryCondition]? = nil

    required init(withName name: String, andText text: String) {
        self.name = name
        self.text = text
    }

    func extractStatistics() -> GameStatistics {
        
        let stats = GameStatistics()
        
        for x in 0..<(self.map?.width)! {
            for y in 0..<(self.map?.height)! {
                
                let tile = self.map?.grid?.tileAt(x: x, y: y)
                
                stats.discoveredTiles += (tile?.discoveredBy(player: .human))! ? 1 : 0
            }
        }
        
        return stats
    }
}
