//
//  City.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 22.02.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation

enum CityError: Error, Equatable {
    case MapNotSet
}

func == (lhs: CityError, rhs: CityError) -> Bool {
    switch (lhs, rhs) {
    case (.MapNotSet, .MapNotSet):
        return true
    }
}

class City: MapItem {
    
    var name: String
    var inhabitants: Int
    var map: Map?
    
    required init(at point: GridPoint, of name: String) {
        
        self.name = name
        self.inhabitants = 50
        
        super.init(at: point)
    }
    
    required init(at point: GridPoint) {
        
        self.name = ""
        self.inhabitants = 50
        
        super.init(at: point)
    }
    
    func terrain() throws -> Terrain {
        
        guard self.map != nil else {
            throw CityError.MapNotSet
        }
        
        return (self.map?.grid?.terrain(at: self.point))!
    }
    
    func isNextToOcean() throws -> Bool {
        
        guard self.map != nil else {
            throw CityError.MapNotSet
        }
        
        return (self.map?.grid?.isNextToOcean(at: self.point))!
    }
    
    func isAdjacentToRiver() throws -> Bool {
        
        guard self.map != nil else {
            throw CityError.MapNotSet
        }
        
        return (self.map?.grid?.tile(at: self.point).isRiver())!
    }
}
