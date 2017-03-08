//
//  ContinentFinderTests.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 06.03.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import XCTest
@testable import HexagonalMapBasic

class ContinentFinderTests: XCTestCase {
    
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
