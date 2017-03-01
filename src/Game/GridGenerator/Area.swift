//
//  Area.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 28.02.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation

class AreaBoundaries {
    
    var topLeft: GridPoint
    var bottomRight: GridPoint
    
    required init(topLeft: GridPoint, bottomRight: GridPoint) {
        
        self.topLeft = topLeft
        self.bottomRight = bottomRight
    }

    func size() -> Int {
        
        let width = bottomRight.x - topLeft.x
        let height = bottomRight.y - topLeft.y
        
        return width * height
    }
}

struct AreaStatistics {
    
    var coastTiles: Int = 0
}

class Area {
    
    let boundaries: AreaBoundaries
    var statistics: AreaStatistics
    let map: Map?
    
    required init(withBoundaries boundaries: AreaBoundaries, on map: Map) {
        
        self.boundaries = boundaries
        self.map = map
        self.statistics = AreaStatistics()
    }
    
    func update() {
        
        // reset values
        self.statistics.coastTiles = 0
        
        for x in self.boundaries.topLeft.x...boundaries.bottomRight.x {
            for y in self.boundaries.topLeft.y...boundaries.bottomRight.y {
                
                guard let tile = self.map?.grid?.tileAt(x: x, y: y) else {
                    continue
                }
                
                guard tile.terrain != .outside else {
                    continue
                }
                
                if (self.map?.grid?.isCoastalAt(x: x, y: y))! {
                    self.statistics.coastTiles += 1
                }
            }
        }
        
    }
}
