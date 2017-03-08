//
//  MapTests.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 22.02.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import XCTest
@testable import HexagonalMapBasic

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

