//
//  MapTests.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 22.02.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import XCTest

class MapTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCityFoundSucceedsOnGrass() {
        
        // Preconditions
        let map = Map(width: 5, height: 5)
        map.grid?.set(terrain: Terrain.grass, at: GridPoint(x: 2, y: 2))
        
        // Stimulus
        let canFound = map.canFoundCity(at: GridPoint(x: 2, y: 2))
        
        // Assertion
        XCTAssertEqual(canFound, true, "city found should succeed on grass")
    }
    
    func testCityFoundFailsOnOcean() {
        
        // Preconditions
        let map = Map(width: 5, height: 5)
        map.grid?.set(terrain: Terrain.ocean, at: GridPoint(x: 2, y: 2))
        
        // Stimulus
        let canFound = map.canFoundCity(at: GridPoint(x: 2, y: 2))
        
        // Assertion
        XCTAssertEqual(canFound, false, "city found should fail on ocean")
    }
    
    func testCityFoundFailsDueToAlreadyFound() {
        
        // Preconditions
        let map = Map(width: 5, height: 5)
        _ = map.foundCity(at: GridPoint(x: 2, y: 2), named: "Berlin")
        
        // Stimulus
        let canFound = map.canFoundCity(at: GridPoint(x: 2, y: 2))
        
        // Assertion
        XCTAssertEqual(canFound, false, "city found should fail due to city already found")
    }
    
    func testCityFoundFailsDueToCityNearby() {
        
        // Preconditions
        let map = Map(width: 5, height: 5)
        _ = map.foundCity(at: GridPoint(x: 2, y: 1), named: "Berlin")
        
        // Stimulus
        let canFound = map.canFoundCity(at: GridPoint(x: 2, y: 2))
        
        // Assertion
        XCTAssertEqual(canFound, false, "city found should fail due to city nearby")
    }
}
