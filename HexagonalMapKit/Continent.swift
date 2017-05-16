//
//  Continent.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 06.03.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation

public class Continent: Area {
    
    public let name: String
    
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

func == (lhs: Continent, rhs: Continent) -> Bool {
    return lhs.identifier == rhs.identifier &&
        lhs.name == rhs.name &&
        lhs.size() == rhs.size() &&
        lhs.contains(points: rhs.points!) &&
        rhs.contains(points: lhs.points!)
}
