//
//  City.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 22.02.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation
import JSONCodable

public enum CityError: Error, Equatable {
    case MapNotSet
}

public func == (lhs: CityError, rhs: CityError) -> Bool {
    switch (lhs, rhs) {
    case (.MapNotSet, .MapNotSet):
        return true
    }
}

public class City: MapItem {
    
    var name: String
    var inhabitants: Int
    var map: Map?
    
    public required init(at point: GridPoint, of name: String) {
        
        self.name = name
        self.inhabitants = 50
        
        super.init(at: point)
    }
    
    public required init(at point: GridPoint) {
        
        self.name = ""
        self.inhabitants = 50
        
        super.init(at: point)
    }
    
    required public init() {
        
        self.name = ""
        self.inhabitants = 50
        
        super.init(at: GridPoint(x: 0, y: 0))
    }
    
    public required init(object: JSONObject) throws {
        fatalError("init(object:) has not been implemented")
    }
    
    public func terrain() throws -> Terrain {
        
        guard self.map != nil else {
            throw CityError.MapNotSet
        }
        
        return (self.map?.grid?.terrain(at: self.point))!
    }
    
    public func isNextToOcean() throws -> Bool {
        
        guard self.map != nil else {
            throw CityError.MapNotSet
        }
        
        return (self.map?.grid?.isNextToOcean(at: self.point))!
    }
    
    public func isAdjacentToRiver() throws -> Bool {
        
        guard self.map != nil else {
            throw CityError.MapNotSet
        }
        
        return (self.map?.grid?.tile(at: self.point).isRiver())!
    }
}
