//
//  GridPoint.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 09.02.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation

/**
 A GridPoint is a structure that represents a location of a hexagon in the grid.
 
 This should be Hashable, so it can be stored in a dictionary.
 ```
 +--+--+--+
 | /    \ |
 |/      \|
 +        +
 |\      /|
 | \    / |
 +--+--+--+
 ```
 */
public class GridPoint : Hashable {
    
    var x: Int = 0
    var y: Int = 0
    
    /**
        builds a GridPoint using the `x` and `y` coordinates
     
        ```
        let gridPoint = GridPoint(x: 1, y: 23)
        ```
     */
    required public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    /**
        Returns a unique number that represents this location.
     */
    public var hashValue: Int {
        return x ^ (y << 32)
    }
}

func even(number: Int) -> Bool {
    // Return true if number is evenly divisible by 2.
    return number % 2 == 0
}

extension GridPoint {
    
    func neighbor(in direction: GridPointDirection) -> GridPoint {
        switch direction {
        case .northEast: 
            if even(number: self.x) {
                return GridPoint(x: self.x + 1, y: self.y - 1)
            } else {
                return GridPoint(x: self.x + 1, y: self.y)
            }
        case .southEast:
            if even(number: self.x) {
                return GridPoint(x: self.x + 1, y: self.y)
            } else {
                return GridPoint(x: self.x + 1, y: self.y + 1)
            }
        case .south:
            return GridPoint(x: self.x, y: self.y + 1)
        case .southWest:
            if even(number: self.x) {
                return GridPoint(x: self.x - 1, y: self.y)
            } else {
                return GridPoint(x: self.x - 1, y: self.y + 1)
            }
        case .northWest:
            if even(number: self.x) {
                return GridPoint(x: self.x - 1, y: self.y - 1)
            } else {
                return GridPoint(x: self.x - 1, y: self.y)
            }
        case .north:
            return GridPoint(x: self.x, y: self.y - 1)
        }
    }
    
    func neighbors() -> [GridPoint] {
        var neighboring = [GridPoint]()
        
        neighboring.append(self.neighbor(in: .northEast))
        neighboring.append(self.neighbor(in: .southEast))
        neighboring.append(self.neighbor(in: .south))
        neighboring.append(self.neighbor(in: .southWest))
        neighboring.append(self.neighbor(in: .northWest))
        neighboring.append(self.neighbor(in: .north))
        
        return neighboring
    }
    
}

// If an object is Hashable, it's also Equatable. To conform
// to the requirements of the Equatable protocol, you need
// to implement the == operation (which returns true if two objects
// are the same, and false if they aren't)
public func == (first : GridPoint, second : GridPoint) -> Bool {
    return first.x == second.x && first.y == second.y
}

extension GridPoint : CustomDebugStringConvertible {
    
    /// A textual representation of this instance, suitable for debugging.
    public var debugDescription: String {
        return "GridPoint(\(self.x),\(self.y))"
    }
}

extension GridPoint : CustomStringConvertible {
    
    /// A textual representation of this instance, suitable for debugging.
    public var description: String {
        return "GridPoint(\(self.x),\(self.y))"
    }
}

extension GridPoint : Equatable {
}
