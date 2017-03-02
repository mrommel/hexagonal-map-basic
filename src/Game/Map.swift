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
 */
class Map {

    var grid: Grid? = nil
    var cities: [City]? = []
    var units: [Unit]? = []
    var improvements: [TileImprovement]? = []
    var continents: [Continent]? = []

    required init(width: Int, height: Int) {

        self.grid = Grid(width: width, height: height)
    }
    
    var width: Int {
        return (self.grid?.width)!
    }
    
    var height: Int {
        return (self.grid?.height)!
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
    
    func foundCityAt(x: Int, y: Int, named name: String) -> Bool {
        
        return self.found(city: City(at: GridPoint(x: x, y: y), of: name))
    }
}


// MARK: continent handling

extension Map {
    
    class ContinentFinder {
        
        static let kNotAnalyzedContinent: Int = 254
        static let kNoContinent: Int = 255
        
        let continentIdentifiers: Array2D<Int>
        
        init(width: Int, height: Int) {
            
            self.continentIdentifiers = Array2D<Int>(columns: width, rows: height)
            
            for x in 0..<width {
                for y in 0..<height {
                    self.continentIdentifiers[x, y] = ContinentFinder.kNotAnalyzedContinent
                }
            }
        }
        
        func evaluated(value: Int) -> Bool {
            
            return value != ContinentFinder.kNotAnalyzedContinent && value != ContinentFinder.kNoContinent
        }
        
        func execute(on map: Map) -> [Continent] {
            
            for x in 0..<self.continentIdentifiers.columnCount() {
                for y in 0..<self.continentIdentifiers.rowCount() {
                    
                    let p0 = GridPoint(x: x, y: y)
                    
                    if (map.grid?.isGround(at: p0))! {
                        let p1 = p0.neighbor(in: .north)
                        let p2 = p0.neighbor(in: .northWest)
                        let p3 = p0.neighbor(in: .southWest)
                        
                        let c1 = (map.grid?.has(gridPoint: p1))! ? (self.continentIdentifiers[p1.x, p1.y])! : ContinentFinder.kNotAnalyzedContinent
                        let c2 = (map.grid?.has(gridPoint: p2))! ? (self.continentIdentifiers[p2.x, p2.y])! : ContinentFinder.kNotAnalyzedContinent
                        let c3 = (map.grid?.has(gridPoint: p3))! ? (self.continentIdentifiers[p3.x, p3.y])! : ContinentFinder.kNotAnalyzedContinent
                        
                        if self.evaluated(value: c1) {
                            self.continentIdentifiers[x, y] = c1
                        } else if self.evaluated(value: c2) {
                            self.continentIdentifiers[x, y] = c2
                        } else if self.evaluated(value: c3) {
                            self.continentIdentifiers[x, y] = c3
                        } else {
                            let freeIdentifier = self.firstFreeIdentifier()
                            self.continentIdentifiers[x, y] = freeIdentifier
                        }
                        
                        // handle continent joins
                        if self.evaluated(value: c1) && self.evaluated(value: c2) && c1 != c2 {
                            self.replace(oldIdentifier: c2, withIdentifier: c1)
                        } else if self.evaluated(value: c2) && self.evaluated(value: c3) && c2 != c3 {
                            self.replace(oldIdentifier: c2, withIdentifier: c3)
                        } else if self.evaluated(value: c1) && self.evaluated(value: c3) && c1 != c3 {
                            self.replace(oldIdentifier: c1, withIdentifier: c3)
                        }
                        
                    } else {
                        self.continentIdentifiers[x, y] = ContinentFinder.kNoContinent
                    }
                }
            }
            
            var continents = [Continent]()
            
            for x in 0..<self.continentIdentifiers.columnCount() {
                for y in 0..<self.continentIdentifiers.rowCount() {
                
                    let continentIdentifier = (self.continentIdentifiers[x, y])!
                    
                    if self.evaluated(value: continentIdentifier) {
                        
                        var continent = continents.first(where: { $0.identifier == continentIdentifier })
                        
                        if continent == nil {
                            continent = Continent(withIdentifier: continentIdentifier, andName: "Continent \(continentIdentifier)", andPoints: [], on: map)
                            continents.append(continent!)
                        }
                        
                        continent?.points?.append(GridPoint(x: x, y: y))
                    }
                }
            }

            return continents
        }
        
        func firstFreeIdentifier() -> Int {
            
            var freeIdentifiers = BitArray(repeating: true, count: 256)
            
            for x in 0..<self.continentIdentifiers.columnCount() {
                for y in 0..<self.continentIdentifiers.rowCount() {
                    
                    let c = (self.continentIdentifiers[x, y])!
                    if c >= 0 && c < 256 {
                        freeIdentifiers[c] = false
                    }
                }
            }
            
            for i in 0..<256 {
                if freeIdentifiers[i] {
                    return i
                }
            }
            
            return ContinentFinder.kNoContinent
        }
        
        func replace(oldIdentifier: Int, withIdentifier newIdentifier: Int) {
            
            for x in 0..<self.continentIdentifiers.columnCount() {
                for y in 0..<self.continentIdentifiers.rowCount() {
                    
                    if (self.continentIdentifiers[x, y])! == oldIdentifier {
                        self.continentIdentifiers[x, y] = newIdentifier
                    }
                }
            }
        }
    }
    
    func findContinents() -> [Continent] {
        
        let continentFinder = ContinentFinder(width: self.width, height: self.height)
        
        return continentFinder.execute(on: self)
    }
    
}


