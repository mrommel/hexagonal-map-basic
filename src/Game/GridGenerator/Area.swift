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
        
        let width = bottomRight.x - topLeft.x
        let height = bottomRight.y - topLeft.y
        
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
    return lhs.identifier == rhs.identifier
}

class Continent: Area {
    
    let name: String
    
    public init(withIdentifier identifier: Int, andName name: String, andBoundaries boundary: AreaBoundary, on map: Map) {
        self.name = name
        super.init(withIdentifier: identifier, andBoundaries: boundary, on: map)
    }
    
    public init(withIdentifier identifier: Int, andName name: String, andPoints points: [GridPoint]?, on map: Map) {
        self.name = name
        super.init(withIdentifier: identifier, andPoints: points, on: map)
    }
}

extension Continent : CustomDebugStringConvertible {
    
    /// A textual representation of this instance, suitable for debugging.
    public var debugDescription: String {
        return "Continent(\(self.identifier),\(self.name))"
    }
}

extension Continent : CustomStringConvertible {
    
    /// A textual representation of this instance, suitable for debugging.
    public var description: String {
        return "Continent(\(self.identifier),\(self.name))"
    }
}
