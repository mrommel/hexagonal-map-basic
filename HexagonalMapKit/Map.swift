//
//  Map.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 22.02.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation
import JSONCodable

extension JSONTransformers {
    
    /*static let JSONObjectType = JSONTransformer<JSONObject, JSONObject>(
        decoding: { $0 },
        encoding: { $0 })*/
    
    static let continentArray = JSONTransformer<[Continent], [Continent]>(
        decoding: { $0 },
        encoding: { $0 })
}

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
public class Map: JSONCodable {

    public var id: String = ""
    public var title: String = ""
    public var teaser: String = ""
    public var text: String = ""
    
    public var grid: Grid? = nil
    public var cities: [City]? = []
    public var units: [Unit]? = []
    public var improvements: [TileImprovement]? = []
    public var continents: [Continent]? = []

    /**
        builds a `Map` with `width`x`height` dimension
     */
    public init(width: Int, height: Int) {
        
        self.id = UUID.init().uuidString
        self.title = "Map \(width)x\(height)"
        self.teaser = "Teaser for manual created"
        self.text = "Full text"
        
        self.grid = Grid(width: width, height: height)
    }
    
    public init(withOptions options: GridGeneratorOptions) {
        
        self.id = UUID.init().uuidString
        self.title = "Map \(options.mapSize.width)x\(options.mapSize.height)"
        self.teaser = "Teaser for generated"
        self.text = "Full text"
        
        self.grid = Grid(width: options.mapSize.width, height: options.mapSize.height)
        self.generate(withOptions: options)
    }
    
    public init(withOptions options: GridGeneratorOptions, completionHandler: CompletionHandler?) {
        
        self.id = UUID.init().uuidString
        self.title = "Map \(options.mapSize.width)x\(options.mapSize.height)"
        self.teaser = "Teaser for generated"
        self.text = "Full text"
        
        self.grid = Grid(width: options.mapSize.width, height: options.mapSize.height)
        self.generate(withOptions: options, completionHandler: completionHandler)
    }
    
    public required init(object: JSONObject) throws {
        let decoder = JSONDecoder(object: object)
        
        self.id = try decoder.decode("id")
        self.title = try decoder.decode("title")
        self.teaser = try decoder.decode("teaser")
        self.text = try decoder.decode("text")

        self.grid = try decoder.decode("grid")
        /*self.cities = try decoder.decode("cities")
        self.units = try decoder.decode("units")
        self.improvements = try decoder.decode("improvements")*/
        self.continents = try decoder.decode("continents")
    }
    
    public func toJSON() throws -> Any {
        return try JSONEncoder.create({ (encoder) -> Void in
            try encoder.encode(self.id, key: "id")
            try encoder.encode(self.title, key: "title")
            try encoder.encode(self.teaser, key: "teaser")
            try encoder.encode(self.text, key: "text")

            try encoder.encode(self.grid, key: "grid")
            /*self.cities = try decoder.decode("cities")
             self.units = try decoder.decode("units")
             self.improvements = try decoder.decode("improvements")*/
            
            if let continents = self.continents {
                try encoder.encode(continents, key: "continents")
            } else {
                let emptyContinents = [Continent]()
                try encoder.encode(emptyContinents, key: "continents")
            }
        })
    }
    
    public var width: Int {
        return (self.grid?.width)!
    }
    
    public var height: Int {
        return (self.grid?.height)!
    }
}

// MARK: generation methods

extension Map {
    
    public func generate(withOptions options: GridGeneratorOptions) {
        
        let generator = GridGenerator(width: self.width, height: self.height)
        generator.completionHandler = { progress in print("progress: \(progress)%") }
        self.grid = generator.generateGrid(with: options)
        
        self.findContinents()
    }
    
    public func generate(withOptions options: GridGeneratorOptions, completionHandler: CompletionHandler?) {
        
        let generator = GridGenerator(width: self.width, height: self.height)
        generator.completionHandler = completionHandler
        self.grid = generator.generateGrid(with: options)
        
        self.findContinents()
    }
}

// MARK: sight related methods

extension Map {
    
    public func discover(at point: GridPoint, by player: PlayerType) {
        self.grid?.tile(at: point).discover(by: player)
    }
    
    public func discovered(at point: GridPoint, by player: PlayerType) -> Bool {
        let discovered = self.grid?.tile(at: point).discovered(by: player)
        return discovered!
    }
}

// MARK: city related methods

extension Map {

    /**
        get the city at <point> position or nil otherwise
     */
    public func city(at point: GridPoint) -> City? {

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
    public func canFoundCity(at point: GridPoint) -> Bool {

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
    public func found(city: City) -> Bool {
        
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
    public func foundCity(at point: GridPoint, named name: String) -> Bool {
        
        return self.found(city: City(at: point, of: name))
    }
    
    @discardableResult
    public func foundCityAt(x: Int, y: Int, named name: String) -> Bool {
        
        return self.found(city: City(at: GridPoint(x: x, y: y), of: name))
    }
}

/// MARK: continent handling

extension Map {
    
    @discardableResult
    public func findContinents() -> [Continent] {
        
        let continentFinder = ContinentFinder(width: self.width, height: self.height)
        
        self.continents = continentFinder.execute(on: self)
        
        if let continents = self.continents {
            return continents
        }
        
        return []
    }
    
    public func continent(at point: GridPoint) -> Continent? {
        
        return self.grid?.tile(at: point).continent
    }
    
    public func set(continent: Continent?, at point: GridPoint) {
        
        self.grid?.tile(at: point).continent = continent
    }
}
