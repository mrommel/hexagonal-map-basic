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
    
    public var name: String
    
    public init(withIdentifier identifier: Int, andName name: String, andBoundaries boundary: AreaBoundary, on map: Map) {
        self.name = name
        super.init(withIdentifier: identifier, andBoundaries: boundary, on: map)
    }
    
    public init(withIdentifier identifier: Int, andName name: String, andPoints points: [GridPoint]?, on map: Map) {
        self.name = name
        super.init(withIdentifier: identifier, andPoints: points, on: map)
    }
    
    required public init() {
        self.name = ""
        super.init()
    }
    
    required convenience public init?(coder: NSCoder) {
        self.init()
    }
    
    override public func setValue(_ value: Any!, forUndefinedKey key: String) {
        
        if key == "name" {
            if let stringValue = value as? String {
                self.name = stringValue
            }
            return
        }
        
        super.setValue(value, forUndefinedKey: key)

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
