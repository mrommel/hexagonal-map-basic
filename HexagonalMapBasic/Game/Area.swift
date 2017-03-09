//
//  Area.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 28.02.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation

/**
 class that holds a rectangle for `Area`
 */
public class AreaBoundary {
    
    var topLeft: GridPoint
    var bottomRight: GridPoint
    
    public required init(topLeft: GridPoint, bottomRight: GridPoint) {
        
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

public struct AreaStatistics {
    
    var coastTiles: Int = 0
}

public class AreaIterator : IteratorProtocol {
    
    var iterationsCount = 0
    var points: [GridPoint]?
    
    required public init(points: [GridPoint]?) {
        self.points = points
    }
    
    public func next() -> GridPoint? {
        guard iterationsCount < (self.points?.count)! else {
            return nil
        }
        let next = self.points?[iterationsCount]
        iterationsCount += 1
        return next
    }
}

/**
    point based area on a map
 
    can be constructed out of a list of points or a rectangle (`AreaBoundary`)
 */
public class Area: Sequence, Equatable {
    
    let identifier: Int
    var points: [GridPoint]?
    var statistics: AreaStatistics
    let map: Map?
    
    /**
        creates a new Area
     
        - Parameter identifier:    unique id to identify the area
        - Parameter boundary:      top+left / bottom+right point of the area
        - Parameter map:           the map where the area lives
     
        ```
        let map = ...
        let boundary = AreaBoundary(topLeft: GridPoint(x: 0, y: 0), bottomRight: GridPoint(x: 1, y: 2))
        let area = Area(withIdentifier: 2, andBoundaries: boundary, on: map)
        ```
     */
    public init(withIdentifier identifier: Int, andBoundaries boundary: AreaBoundary, on map: Map) {
        
        self.identifier = identifier
        self.points = boundary.allPoints()
        self.map = map
        self.statistics = AreaStatistics()
    }
    
    /**
         creates a new Area
         
         - Parameter identifier:    unique id to identify the area
         - Parameter boundary:      top+left / bottom+right point of the area
         - Parameter map:           the map where the area lives
     
        ```
        let map = ...
        let area = Area(withIdentifier: 2, andBoundaries: [GridPoint(x: 1, y: 2)], on: map)
        ```
     */
    public init(withIdentifier identifier: Int, andPoints points: [GridPoint]?, on map: Map) {
        
        self.identifier = identifier
        self.points = points
        self.map = map
        self.statistics = AreaStatistics()
    }
    
    public func makeIterator() -> AreaIterator {
        return AreaIterator(points: self.points)
    }
    
    public func size() -> Int {
        return (self.points?.count)!
    }
    
    public func contains(points: [GridPoint]) -> Bool {
        
        for point in points {
            if !self.contains(where: { $0.x == point.x && $0.y == point.y }) {
                return false
            }
        }
        
        return true
    }

    public func update() {
        
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

public func == (lhs: Area, rhs: Area) -> Bool {
    return lhs.identifier == rhs.identifier && lhs.size() == rhs.size() && lhs.contains(points: rhs.points!) && rhs.contains(points: lhs.points!)
}
