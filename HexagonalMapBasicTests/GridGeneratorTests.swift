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
}
