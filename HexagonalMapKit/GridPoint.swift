//
//  GridPoint.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 09.02.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation
import CoreGraphics
import JSONCodable

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
public class GridPoint: Hashable, JSONCodable {
    
    public var x: Int = 0
    public var y: Int = 0
    
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
    
    required public init(object: JSONObject) throws {
        let decoder = JSONDecoder(object: object)
        
        self.x = try decoder.decode("x")
        self.y = try decoder.decode("y")
    }
    
    /**
     Returns a unique number that represents this location.
     */
    public var hashValue: Int {
        return self.x << 8 + self.y + 31
    }
}

func even(number: Int) -> Bool {
    // Return true if number is evenly divisible by 2.
    return number % 2 == 0
}

extension GridPoint {
    
    public func neighbor(in direction: GridPointDirection) -> GridPoint {
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
    
    public func neighbors() -> [GridPoint] {
        
        var neighboring = [GridPoint]()
        
        neighboring.append(self.neighbor(in: .northEast))
        neighboring.append(self.neighbor(in: .southEast))
        neighboring.append(self.neighbor(in: .south))
        neighboring.append(self.neighbor(in: .southWest))
        neighboring.append(self.neighbor(in: .northWest))
        neighboring.append(self.neighbor(in: .north))
        
        return neighboring
    }
    
    public func distance(towards point: GridPoint) -> Int {
        
        let dx = point.x - self.x
        let dy = point.y - self.y
        
        if dx.sign() == dy.sign() {
            // this is (1); see first paragraph
            return max(abs(dx), abs(dy))
        } else {
            return abs(dx) + abs(dy)
        }
    }
    
    public func angle(towards point: GridPoint) -> Float {

        let s = self.screenPoint()
        let p = point.screenPoint()
        let dx: Float = Float(p.x - s.x)
        let dy: Float = Float(p.y - s.y)
        
        if dy == 0 {
            return dx >= 0 ? 0.0 : 180.0
        } else {
            let t = Float.rad2Deg(angleInRad: atan2(dx, dy))
            if t >= 0 {
                return Float.reduceAngle(angle: Float((dy > 0) ? (Int)(t + 270) : (Int)(t - 90)))
            } else {
                return Float.reduceAngle(angle: Float( (Int)(t + 270) ) )
            }
        }
    }
    
    /**
     northEast: 29.0
     southEast: 330.0
     south: 270.0
     southWest: 209.0
     northWest: 150.0
     north: 90.0
     */
    public func direction(towards point: GridPoint) -> GridPointDirection {
        
        let angle = self.angle(towards: point)
        
        if 0 <= angle && angle < 60 {
            return .northEast
        } else if 60 <= angle && angle < 120 {
            return .north
        } else if 120 <= angle && angle < 180 {
            return .northWest
        } else if 180 <= angle && angle < 240 {
            return .southWest
        } else if 240 <= angle && angle < 300 {
            return .south
        } else if 300 <= angle && angle < 360 {
            return .southEast
        }
        
        assert(false, "angle \(angle) should be 0..360")
        
        return .north
    }
    
    public func adjacentPoints(of corner: GridPointCorner) -> [GridPoint] {
        
        var neighboring = [GridPoint]()
        
        neighboring.append(self)
        
        switch corner {
        case .northEast:
            neighboring.append(self.neighbor(in: .north))
            neighboring.append(self.neighbor(in: .northEast))
            break
        case .east:
            neighboring.append(self.neighbor(in: .northEast))
            neighboring.append(self.neighbor(in: .southEast))
            break
        case .southEast:
            neighboring.append(self.neighbor(in: .southEast))
            neighboring.append(self.neighbor(in: .south))
            break
        case .southWest:
            neighboring.append(self.neighbor(in: .south))
            neighboring.append(self.neighbor(in: .southWest))
            break
        case .west:
            neighboring.append(self.neighbor(in: .southWest))
            neighboring.append(self.neighbor(in: .northWest))
            break
        case .northWest:
            neighboring.append(self.neighbor(in: .northWest))
            neighboring.append(self.neighbor(in: .north))
            break
        }
        
        return neighboring
    }
    
    public func screenPoint() -> CGPoint {
        return CGPoint(x: Double(self.x) * Grid.kHexagonWidth * 3 / 4,
                       y: Double(self.y) * Grid.kHexagonHeight + (even(number: Int(self.x)) ? 0 : Grid.kHexagonHeight / 2))
    }
}

// If an object is Hashable, it's also Equatable. To conform
// to the requirements of the Equatable protocol, you need
// to implement the == operation (which returns true if two objects
// are the same, and false if they aren't)
public func == (first : GridPoint, second : GridPoint) -> Bool {
    return first.x == second.x && first.y == second.y
}
