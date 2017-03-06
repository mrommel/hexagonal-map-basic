//
//  GridGeneratorTests.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 13.02.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import XCTest

class GridGeneratorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFillTerrain() {
        
        let gridGenerator = GridGenerator(width: 2, height: 2)
        let terrain = Terrain.snow
        
        gridGenerator.fill(with: terrain)
        
        let grid = gridGenerator.generate()
        
        XCTAssertEqual(grid?.terrain(at: GridPoint(x: 0, y: 0)), Terrain.snow, "terrain does not match")
        XCTAssertEqual(grid?.terrain(at: GridPoint(x: 0, y: 1)), Terrain.snow, "terrain does not match")
        XCTAssertEqual(grid?.terrain(at: GridPoint(x: 1, y: 0)), Terrain.snow, "terrain does not match")
        XCTAssertEqual(grid?.terrain(at: GridPoint(x: 1, y: 1)), Terrain.snow, "terrain does not match")
    }
    
    func testFillFromElevationAtLeastHalfOcean() {
        
        let gridGenerator = GridGenerator(width: 20, height: 20)
        gridGenerator.fillFromElevation(withWaterPercentage: 0.5)
        
        let grid = gridGenerator.generate()
        
        var oceanTiles = 0
        
        for x in 0..<20 {
            for y in 0..<20 {
                if (grid?.terrainAt(x: x, y: y).isWater)! {
                    oceanTiles += 1
                }
            }
        }
        
        XCTAssertGreaterThanOrEqual(oceanTiles, 200, "expected are more than 200 tiles occupied by ocen")
    }
    
    func testIdentifyClimateZoneIdentification() {
        
        // Preconditions
        let gridGenerator = GridGenerator(width: 20, height: 20)
        
        // Stimulus
        let zones = gridGenerator.identifyClimateZones()
        
        // Assertion
        XCTAssertEqual(zones[0, 0], .polar, "wrong climate zone")
        XCTAssertEqual(zones[10, 0], .polar, "wrong climate zone")
        XCTAssertEqual(zones[19, 0], .polar, "wrong climate zone")
        XCTAssertEqual(zones[0, 19], .polar, "wrong climate zone")
        XCTAssertEqual(zones[10, 19], .polar, "wrong climate zone")
        XCTAssertEqual(zones[19, 19], .polar, "wrong climate zone")
        
        XCTAssertEqual(zones[0, 3], .subpolar, "wrong climate zone")
        XCTAssertEqual(zones[10, 3], .subpolar, "wrong climate zone")
        XCTAssertEqual(zones[19, 3], .subpolar, "wrong climate zone")
        XCTAssertEqual(zones[0, 18], .subpolar, "wrong climate zone")
        XCTAssertEqual(zones[10, 18], .subpolar, "wrong climate zone")
        XCTAssertEqual(zones[19, 18], .subpolar, "wrong climate zone")
        
        XCTAssertEqual(zones[0, 5], .temperate, "wrong climate zone")
        XCTAssertEqual(zones[10, 5], .temperate, "wrong climate zone")
        XCTAssertEqual(zones[19, 5], .temperate, "wrong climate zone")
        XCTAssertEqual(zones[0, 16], .temperate, "wrong climate zone")
        XCTAssertEqual(zones[10, 16], .temperate, "wrong climate zone")
        XCTAssertEqual(zones[19, 16], .temperate, "wrong climate zone")
        
        XCTAssertEqual(zones[0, 7], .subtropic, "wrong climate zone")
        XCTAssertEqual(zones[10, 7], .subtropic, "wrong climate zone")
        XCTAssertEqual(zones[19, 7], .subtropic, "wrong climate zone")
        XCTAssertEqual(zones[0, 13], .subtropic, "wrong climate zone")
        XCTAssertEqual(zones[10, 13], .subtropic, "wrong climate zone")
        XCTAssertEqual(zones[19, 13], .subtropic, "wrong climate zone")
        
        XCTAssertEqual(zones[0, 9], .tropic, "wrong climate zone")
        XCTAssertEqual(zones[10, 9], .tropic, "wrong climate zone")
        XCTAssertEqual(zones[19, 9], .tropic, "wrong climate zone")
        XCTAssertEqual(zones[0, 10], .tropic, "wrong climate zone")
        XCTAssertEqual(zones[10, 10], .tropic, "wrong climate zone")
        XCTAssertEqual(zones[19, 10], .tropic, "wrong climate zone")
    }
}
