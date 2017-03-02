//
//  MapTests.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 22.02.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import XCTest

class MapTests: XCTestCase {
    
    func testCityCanFoundSucceedsOnGrass() {
        
        // Preconditions
        let map = Map(width: 5, height: 5)
        map.grid?.set(terrain: Terrain.grass, at: GridPoint(x: 2, y: 2))
        
        // Stimulus
        let canFound = map.canFoundCity(at: GridPoint(x: 2, y: 2))
        
        // Assertion
        XCTAssertEqual(canFound, true, "city found should succeed on grass")
    }
    
    func testCityCanFoundFailsOnOcean() {
        
        // Preconditions
        let map = Map(width: 5, height: 5)
        map.grid?.set(terrain: Terrain.ocean, at: GridPoint(x: 2, y: 2))
        
        // Stimulus
        let canFound = map.canFoundCity(at: GridPoint(x: 2, y: 2))
        
        // Assertion
        XCTAssertEqual(canFound, false, "city found should fail on ocean")
    }
    
    func testCityCanFoundFailsDueToAlreadyFound() {
        
        // Preconditions
        let map = Map(width: 5, height: 5)
        map.grid?.set(terrain: Terrain.grass, at: GridPoint(x: 2, y: 2))
        _ = map.foundCity(at: GridPoint(x: 2, y: 2), named: "Berlin")
        
        // Stimulus
        let canFound = map.canFoundCity(at: GridPoint(x: 2, y: 2))
        
        // Assertion
        XCTAssertEqual(canFound, false, "city found should fail due to city already found")
    }
    
    func testCityCanFoundFailsDueToCityNearby() {
        
        // Preconditions
        let map = Map(width: 5, height: 5)
        map.grid?.set(terrain: Terrain.grass, at: GridPoint(x: 2, y: 2))
        map.grid?.set(terrain: Terrain.grass, at: GridPoint(x: 2, y: 1))
        _ = map.foundCity(at: GridPoint(x: 2, y: 1), named: "Berlin")
        
        // Stimulus
        let canFound = map.canFoundCity(at: GridPoint(x: 2, y: 2))
        
        // Assertion
        XCTAssertEqual(canFound, false, "city found should fail due to city nearby")
    }
    
    func testCityFoundSucceedsAndChopsForest() {
        
        // Preconditions
        let map = Map(width: 5, height: 5)
        map.grid?.set(terrain: Terrain.grass, at: GridPoint(x: 2, y: 2))
        map.grid?.add(feature: Feature.forest, at: GridPoint(x: 2, y: 2))
        
        // Stimulus
        let wasFound = map.foundCity(at: GridPoint(x: 2, y: 2), named: "Potsdam")
        
        // Assertion
        XCTAssertEqual(wasFound, true, "city found should succeed")
        let hasForest = map.grid?.has(feature: Feature.forest, at: GridPoint(x: 2, y: 2))
        XCTAssertFalse(hasForest!, "forest should have been removed during settlement")
    }
}


// MARK: continent related tests

extension MapTests {
    
    func testContinentGenerationNoContinents() {
        
        // Preconditions
        let map = Map(width: 5, height: 5)
        
        // Stimulus
        let continents = map.findContinents()
        
        // Assertion
        XCTAssertEqual(continents.count, 0, "wrong number of continents found")
    }
    
    func testContinentGenerationSmallContinents() {
        
        // Preconditions
        let map = Map(width: 5, height: 5)
        map.grid?.set(terrain: Terrain.grass, at: GridPoint(x: 1, y: 2))
        map.grid?.set(terrain: Terrain.grass, at: GridPoint(x: 1, y: 3))
        map.grid?.set(terrain: Terrain.grass, at: GridPoint(x: 3, y: 4))
        map.grid?.set(terrain: Terrain.grass, at: GridPoint(x: 4, y: 1))
        
        // Stimulus
        let continents = map.findContinents()
        
        // Assertion
        XCTAssertEqual(continents.count, 3, "wrong number of continents found")
    }
    
    func testContinentGenerationJoinedContinents() {
        
        // Preconditions
        let map = Map(width: 5, height: 5)
        map.grid?.set(terrain: Terrain.grass, at: GridPoint(x: 1, y: 0))
        map.grid?.set(terrain: Terrain.grass, at: GridPoint(x: 1, y: 1))
        map.grid?.set(terrain: Terrain.grass, at: GridPoint(x: 1, y: 2))
        map.grid?.set(terrain: Terrain.grass, at: GridPoint(x: 1, y: 3))
        map.grid?.set(terrain: Terrain.grass, at: GridPoint(x: 2, y: 3))
        map.grid?.set(terrain: Terrain.grass, at: GridPoint(x: 3, y: 3))
        map.grid?.set(terrain: Terrain.grass, at: GridPoint(x: 4, y: 3))
        map.grid?.set(terrain: Terrain.grass, at: GridPoint(x: 4, y: 2))
        map.grid?.set(terrain: Terrain.grass, at: GridPoint(x: 4, y: 1))
        map.grid?.set(terrain: Terrain.grass, at: GridPoint(x: 4, y: 0))
        
        // Stimulus
        let continents = map.findContinents()
        
        // Assertion
        XCTAssertEqual(continents.count, 1, "wrong number of continents found")
        let uContinent = continents[0]
        XCTAssertEqual(uContinent.size(), 10, "size of continent is wrong")
    }
    
    func testContinentGenerationCorrectSizes() {
        
        // Preconditions
        let map = Map(width: 5, height: 5)
        map.grid?.set(terrain: Terrain.grass, at: GridPoint(x: 1, y: 2))
        map.grid?.set(terrain: Terrain.grass, at: GridPoint(x: 1, y: 3))
        map.grid?.set(terrain: Terrain.grass, at: GridPoint(x: 3, y: 4))
        map.grid?.set(terrain: Terrain.grass, at: GridPoint(x: 4, y: 1))
        
        // Stimulus
        map.findContinents()
        
        // Assertion
        let continent0 = map.continent(at: GridPoint(x: 1, y: 2))!
        let continent1 = map.continent(at: GridPoint(x: 1, y: 3))!
        XCTAssertEqual(continent0.size(), 2, "wrong size of continent found")
        XCTAssertEqual(continent1.size(), 2, "wrong size of continent found")
        XCTAssertEqual(continent0, continent1, "continent should be the same")
    }
}
