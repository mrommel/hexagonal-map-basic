//
//  Continent.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 06.03.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation
import EVReflection

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
    
    required public init() {
        fatalError("init() has not been implemented")
    }
    
    required convenience public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func skipPropertyValue(_ value: Any, key: String) -> Bool {
        
        if key == "map" {
            return true
        }
        
        if key == "statistics" {
            return true
        }
        
        return false
    }
}

func == (lhs: Continent, rhs: Continent) -> Bool {
    return lhs.identifier == rhs.identifier &&
        lhs.name == rhs.name &&
        lhs.size() == rhs.size() &&
        lhs.contains(points: rhs.points!) &&
        rhs.contains(points: lhs.points!)
}
