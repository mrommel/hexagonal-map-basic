//
//  Map.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 22.02.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation
import Buckets

/**
    Map class that contains the actual grid, a list of cities, units and improvements
 
    is part of a game
 
 
    it is the holder structure of
    - a `Grid`
    - a list of `City`s
    - a list of `Unit`s
    - a list of `TileImprovement`s
    - a list of `Continent`s
 */
public class Map {

    var grid: Grid?
    var cities: [City]? = []
    var units: [Unit]? = []
    var improvements: [TileImprovement]? = []
    var continents: [Continent]? = []

    /**
        builds a `Map` with `width`x`height` dimension
     */
    public required init(width: Int, height: Int) {

        self.grid = Grid(width: width, height: height)
    }
    
    var width: Int {
        return (self.grid?.width)!
    }
    
    var height: Int {
        return (self.grid?.height)!
    }
}

// MARK: generation methods

extension Map {
    
    func generate(withWaterPercentage waterPercentage: Float) {
        
        let options = GridGeneratorOptions(climateZoneOption: .earth, waterPercentage: 0.4)
        
        let generator = GridGenerator(width: self.width, height: self.height)
        generator.completionHandler = { progress in print("progress: \(progress)%") }
        self.grid = generator.generateGrid(with: options)
    }
}

// MARK: sight related methods

extension Map {
    
    func discover(at point: GridPoint, by player: PlayerType) {
        self.grid?.tile(at: point).discover(by: player)
    }
    
    func discovered(at point: GridPoint, by player: PlayerType) -> Bool {
        let discovered = self.grid?.tile(at: point).discovered(by: player)
        return discovered!
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
        
        // remove forest
        let hasForest = self.grid?.has(feature: Feature.forest, at: city.point)
        if hasForest! {
            self.grid?.remove(feature: Feature.forest, at: city.point)
        }
        
        return true
    }

    @discardableResult
    func foundCity(at point: GridPoint, named name: String) -> Bool {
        
        return self.found(city: City(at: point, of: name))
    }
    
    @discardableResult
    func foundCityAt(x: Int, y: Int, named name: String) -> Bool {
        
        return self.found(city: City(at: GridPoint(x: x, y: y), of: name))
    }
}

// MARK: continent handling

extension Map {
    
    @discardableResult
    func findContinents() -> [Continent] {
        
        let continentFinder = ContinentFinder(width: self.width, height: self.height)
        
        self.continents = continentFinder.execute(on: self)
        
        if let continents = self.continents {
            return continents
        }
        
        return []
    }
    
    func continent(at point: GridPoint) -> Continent? {
        
        return self.grid?.tile(at: point).continent
    }
    
    func set(continent: Continent?, at point: GridPoint) {
        
        self.grid?.tile(at: point).continent = continent
    }
}
