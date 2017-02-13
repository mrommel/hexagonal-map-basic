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
        let terrain = Terrain(terrainType: .snow)
        
        gridGenerator?.fill(with: terrain)
        
        let grid = gridGenerator?.generate()
        
        XCTAssertEqual(grid?.terrain(at: GridPoint(x: 0, y: 0)).terrainType, TerrainType.snow, "terrain does not match")
        XCTAssertEqual(grid?.terrain(at: GridPoint(x: 0, y: 1)).terrainType, TerrainType.snow, "terrain does not match")
        XCTAssertEqual(grid?.terrain(at: GridPoint(x: 1, y: 0)).terrainType, TerrainType.snow, "terrain does not match")
        XCTAssertEqual(grid?.terrain(at: GridPoint(x: 1, y: 1)).terrainType, TerrainType.snow, "terrain does not match")
    }
    
}
