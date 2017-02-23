//
//  Map.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 22.02.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation

/**
 Map class that contains the actual grid, a list of cities, units and improvements
 
 is part of a game
 */
class Map {

    var grid: Grid? = nil
    var cities: [City]? = []
    var units: [Unit]? = []
    var improvements: [TileImprovement]? = []

    required init(width: Int, height: Int) {

        self.grid = Grid(width: width, height: height)
    }
}

// MARK: city related methods

extension Map {

    /**
        get the city at <point> position or nil otherwise
     */
    func city(at point: GridPoint) -> City? {

        guard self.cities != nil else {
            return nil
        }

        if let cities = self.cities {
            for city in cities {
                if city.point == point {
                    return city
                }
            }
        }

        return nil
    }

    /**
        check point and neighboring tiles, if they are empty (without city)
     
        checks also the terrain
     
        - parameter point: location to check if a city can be founded here
     
        - returns: true if this spot (and the neighboring tiles are empty/not occupied by another city)
     */
    func canFoundCity(at point: GridPoint) -> Bool {

        // is there a city at this tile already?
        if self.city(at: point) != nil {
            return false
        }

        // check neighboring tiles
        for neighbor in point.neighbors() {
            if self.city(at: neighbor) != nil {
                return false
            }
        }

        // check if terrain allow city founding
        if !(self.grid?.terrain(at: point).canFoundCity)! {
            return false
        }

        return true
    }

    /**
        actually found a city here
     
        - parameter city: city to be found at city.point location
     
        - returns: true, if city was found, false otherwise
     */
    func found(city: City) -> Bool {
        
        // we need to check if we can found here
        if !self.canFoundCity(at: city.point) {
            return false
        }
        
        // add the city here
        self.cities?.append(city)
        city.map = self
        
        return true
    }

    func foundCity(at point: GridPoint, named name: String) -> Bool {
        
        return self.found(city: City(at: point, of: name))
    }
    
    func foundCityAt(x: Int, y: Int, named name: String) -> Bool {
        
        return self.found(city: City(at: GridPoint(x: x, y: y), of: name))
    }
}
