//
//  GridPointCorner.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 04.04.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation

/**
    A GridPointCorner is an enum that represents a corner of a `GridPoint`.

    There are 6 (0-5) corners
    ```
    +--5--0--+
    | /    \ |
    |/      \|
    4        1
    |\      /|
    | \    / |
    +--3--2--+
    ```
 */
enum GridPointCorner: Int {
    
    case northEast  = 0
    case east       = 1
    case southEast  = 2
    case southWest  = 3
    case west       = 4
    case northWest  = 5

}

func randomGridPointCorner() -> GridPointCorner {
    return GridPointCorner(rawValue: Int.random(num: 6))!
}

public class GridPointWithCorner: Hashable {
    
    let point: GridPoint
    let corner: GridPointCorner
    
    init(with point: GridPoint, andCorner corner: GridPointCorner) {
        self.point = point
        self.corner = corner
    }
    
    /**
        Returns a unique number that represents this location.
     */
    public var hashValue: Int {
        return self.point.hashValue << 4 + self.corner.rawValue
    }
    
    func adjacentCorners() -> [GridPointWithCorner] {
        
        var corners: [GridPointWithCorner] = []
        let northNeighor = self.point.neighbor(in: .north)
        let northEastNeighor = self.point.neighbor(in: .northEast)
        let southEastNeighbor = self.point.neighbor(in: .southEast)
        let southNeighbor = self.point.neighbor(in: .south)
        let southWestNeighbor = self.point.neighbor(in: .southWest)
        let northWestNeighbor = self.point.neighbor(in: .northWest)
        
        switch self.corner {
        case .northEast:
            corners.append(GridPointWithCorner(with: northNeighor, andCorner: .east))
            corners.append(GridPointWithCorner(with: self.point, andCorner: .east)) // 1
            corners.append(GridPointWithCorner(with: self.point, andCorner: .northWest)) // 5
            break
        case .east:
            corners.append(GridPointWithCorner(with: northEastNeighor, andCorner: .southEast))
            corners.append(GridPointWithCorner(with: self.point, andCorner: .southEast)) // 2
            corners.append(GridPointWithCorner(with: self.point, andCorner: .northEast)) // 0
            break
        case .southEast:
            corners.append(GridPointWithCorner(with: self.point, andCorner: .east)) // 1
            corners.append(GridPointWithCorner(with: southEastNeighbor, andCorner: .southWest))
            corners.append(GridPointWithCorner(with: self.point, andCorner: .southWest)) // 3
            break
        case .southWest:
            corners.append(GridPointWithCorner(with: self.point, andCorner: .southEast)) // 2
            corners.append(GridPointWithCorner(with: southNeighbor, andCorner: .west))
            corners.append(GridPointWithCorner(with: self.point, andCorner: .west)) // 4
            break
        case .west:
            corners.append(GridPointWithCorner(with: self.point, andCorner: .northWest)) // 5
            corners.append(GridPointWithCorner(with: self.point, andCorner: .southWest)) // 3
            corners.append(GridPointWithCorner(with: southWestNeighbor, andCorner: .northWest))
            break
        case .northWest:
            corners.append(GridPointWithCorner(with: self.point, andCorner: .northEast)) // 0
            corners.append(GridPointWithCorner(with: self.point, andCorner: .west)) // 4
            corners.append(GridPointWithCorner(with: northWestNeighbor, andCorner: .northEast))
            break
        }
        
        return corners
    }
}

// If an object is Hashable, it's also Equatable. To conform
// to the requirements of the Equatable protocol, you need
// to implement the == operation (which returns true if two objects
// are the same, and false if they aren't)
public func == (first : GridPointWithCorner, second : GridPointWithCorner) -> Bool {
    return first.point.x == second.point.x && first.point.y == second.point.y && first.corner == second.corner
}

extension GridPointWithCorner : CustomDebugStringConvertible {
    
    /// A textual representation of this instance, suitable for debugging.
    public var debugDescription: String {
        return "GridPointWithCorner(\(self.point.x),\(self.point.y) / \(self.corner))"
    }
}

extension GridPointWithCorner : CustomStringConvertible {
    
    /// A textual representation of this instance, suitable for debugging.
    public var description: String {
        return "GridPointWithCorner(\(self.point.x),\(self.point.y) / \(self.corner))"
    }
}

extension GridPointWithCorner: Equatable {
    
}
