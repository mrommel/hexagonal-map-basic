//
//  CityTests.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 01.03.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import XCTest

class CityTests: XCTestCase {
    
    func testTerrainMapAssigned() {
        
        // Preconditions
        let map = Map(width: 5, height: 5)
        let cityPosition = GridPoint(x: 2, y: 2)
        map.grid?.set(terrain: .grass, at: cityPosition)
        map.foundCity(at: cityPosition, named: "Berlin")
        let city = map.city(at: cityPosition)
        
        // Stimulus
        var cityTerrain = Terrain.outside
        do {
            cityTerrain = try (city?.terrain())!
        } catch {
            XCTFail("map not assigned")
        }
        
        // Assertion
        XCTAssertEqual(cityTerrain, .grass, "terrain should be grass")
    }
    
    func testTerrainMapNotAssigned() {
        
        // Preconditions
        let map = Map(width: 5, height: 5)
        let cityPosition = GridPoint(x: 2, y: 2)
        map.grid?.set(terrain: .grass, at: cityPosition)
        map.foundCity(at: cityPosition, named: "Berlin")
        let city = map.city(at: cityPosition)
        city?.map = nil
        
        // Stimulus
        do {
            let _ = try (city?.terrain())!
        } catch {
            // Assertion
            XCTAssertEqual(error as! CityError, CityError.MapNotSet, "")
            return
        }
        
        XCTFail("map should not be assigned")
    }
}
