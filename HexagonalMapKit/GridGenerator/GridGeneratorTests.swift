//
//  GridGeneratorTests.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 13.02.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import XCTest
@testable import HexagonalMapBasic

class GridGeneratorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFillFromElevationAtLeastHalfOcean() {
        
        let gridGenerator = GridGenerator(width: 20, height: 20)

        let options = GridGeneratorOptions(climateZoneOption: .earth, waterPercentage: 0.5, rivers: 0)
        let grid = gridGenerator.generateGrid(with: options)
        
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
    
    func testMap() {
        
        let gridGenerator = GridGenerator(width: 20, height: 20)
        
        let options = GridGeneratorOptions(climateZoneOption: .earth, waterPercentage: 0.5, rivers: 10)
        let grid = gridGenerator.generateGrid(with: options)
        
    }
}
