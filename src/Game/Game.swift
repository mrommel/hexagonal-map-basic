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

class MapItem {
    
    let point: GridPoint
    
    required init(withPoint point: GridPoint) {
        self.point = point
    }
}

class City: MapItem {
    
}

class Unit: MapItem {
    
}

class TileImprovement: MapItem {
    
}

class Map {
    
    var grid: Grid? = nil
    var cities: [City]? = []
    var units: [Unit]? = []
    var improvements: [TileImprovement]? = []
}

class Game {
 
    let name: String
    let text: String
    
    var map: Map? = nil
    var condition: VictoryCondition? = nil
    
    required init(withName name: String, andText text: String) {
        self.name = name
        self.text = text
    }
    
}
