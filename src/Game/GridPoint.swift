//
//  GridPoint.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 09.02.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation

enum GridPointDirection {
    
    case northEast
    case east
    case southEast
    case southWest
    case west
    case northWest
    
    func text() -> String {
        switch self {
        case .northEast:
            return "northEast"
        case .east:
            return "east"
        case .southEast:
            return "southEast"
        case .southWest:
            return "southWest"
        case .west:
            return "west"
        case .northWest:
            return "northWest"
        }
    }
}

// A GridPoint is a structure that represents a location in the grid.
// This is Hashable, because it will be stored in a dictionary.
class GridPoint : Hashable {
    
    var x: Int = 0;
    var y: Int = 0;
    
    required public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    // Returns a unique number that represents this location.
    var hashValue: Int {
        get {
            return x ^ (y << 32)
        }
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
                return GridPoint(x: self.x, y: self.y - 1)
            } else {
                return GridPoint(x: self.x + 1, y: self.y - 1)
            }
        case .east:
            return GridPoint(x: self.x + 1, y: self.y)
        case .southEast:
            if even(number: self.x) {
                return GridPoint(x: self.x, y: self.y + 1)
            } else {
                return GridPoint(x: self.x + 1, y: self.y + 1)
            }
        case .southWest:
            if even(number: self.x) {
                return GridPoint(x: self.x - 1, y: self.y + 1)
            } else {
                return GridPoint(x: self.x, y: self.y + 1)
            }
        case .west:
            return GridPoint(x: self.x - 1, y: self.y)
        case .northWest:
            if even(number: self.x) {
                return GridPoint(x: self.x - 1, y: self.y - 1)
            } else {
                return GridPoint(x: self.x, y: self.y - 1)
            }
        }
    }
    
    //func isInside(bounds: )
    
}

// If an object is Hashable, it's also Equatable. To conform
// to the requirements of the Equatable protocol, you need
// to implement the == operation (which returns true if two objects
// are the same, and false if they aren't)
func ==(first : GridPoint, second : GridPoint) -> Bool {
    return first.x == second.x && first.y == second.y
}

extension GridPoint : CustomDebugStringConvertible {
    
    /// A textual representation of this instance, suitable for debugging.
    public var debugDescription: String {
        return "GridPoint(\(self.x),\(self.y))"
    }
}

extension GridPoint : Equatable {
}
