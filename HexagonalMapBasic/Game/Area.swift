//
//  Area.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 28.02.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation

class AreaBoundary {
    
    var topLeft: GridPoint
    var bottomRight: GridPoint
    
    required init(topLeft: GridPoint, bottomRight: GridPoint) {
        
        self.topLeft = topLeft
        self.bottomRight = bottomRight
    }
    
    func allPoints() -> [GridPoint] {
        
        var points = [GridPoint]()
        
        for x in self.topLeft.x...bottomRight.x {
            for y in self.topLeft.y...bottomRight.y {
                points.append(GridPoint(x: x, y: y))
            }
        }
        
        return points
    }

    func size() -> Int {
        
        let width = bottomRight.x - topLeft.x + 1
        let height = bottomRight.y - topLeft.y + 1
        
        return width * height
    }
}

struct AreaStatistics {
    
    var coastTiles: Int = 0
}

class AreaIterator : IteratorProtocol {
    
    var iterationsCount = 0
    var points: [GridPoint]?
    
    required init(points: [GridPoint]?) {
        self.points = points
    }
    
    func next() -> GridPoint? {
        guard iterationsCount < (self.points?.count)! else {
            return nil
        }
        let next = self.points?[iterationsCount]
        iterationsCount += 1
        return next
    }
}

class Area: Sequence, Equatable {
    
    let identifier: Int
    var points: [GridPoint]?
    var statistics: AreaStatistics
    let map: Map?
    
    public init(withIdentifier identifier: Int, andBoundaries boundary: AreaBoundary, on map: Map) {
        
        self.identifier = identifier
        self.points = boundary.allPoints()
        self.map = map
        self.statistics = AreaStatistics()
    }
    
    public init(withIdentifier identifier: Int, andPoints points: [GridPoint]?, on map: Map) {
        
        self.identifier = identifier
        self.points = points
        self.map = map
        self.statistics = AreaStatistics()
    }
    
    func makeIterator() -> AreaIterator {
        return AreaIterator(points: self.points)
    }
    
    func size() -> Int {
        return (self.points?.count)!
    }
    
    func contains(points: [GridPoint]) -> Bool {
        
        for point in points {
            if !self.contains(where: { $0.x == point.x && $0.y == point.y }) {
                return false
            }
        }
        
        return true
    }

    func update() {
        
        // reset values
        self.statistics.coastTiles = 0
        
        for point in self {
            
            guard let tile = self.map?.grid?.tileAt(x: point.x, y: point.y) else {
                continue
            }
            
            guard tile.terrain != .outside else {
                continue
            }
            
            if (self.map?.grid?.isCoastalAt(x: point.x, y: point.y))! {
                self.statistics.coastTiles += 1
            }
        }
        
    }
}

func ==(lhs: Area, rhs: Area) -> Bool {
    return lhs.identifier == rhs.identifier && lhs.size() == rhs.size() && lhs.contains(points: rhs.points!) && rhs.contains(points: lhs.points!)
}
