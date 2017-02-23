//
//  GridTests.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 09.02.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import XCTest

class GridTests: XCTestCase {
    
    func testDefaultInit() {

        // Preconditions
        let grid = Grid(width: 5, height: 5)
        
        for x in 0..<5 {
            for y in 0..<5 {
                // Stimulus
                let terrain = grid?.terrain(at: GridPoint(x: x, y: y))
                
                // Assertion
                XCTAssertEqual(terrain, Terrain.ocean, "terrain does not match")
            }
        }
    }
    
    func testOutside() {
        
        // Preconditions
        let grid = Grid(width: 5, height: 5)
        
        // Stimulus
        let terrain = grid?.terrain(at: GridPoint(x: -1, y: -1))
        
        // Assertion
        XCTAssertEqual(terrain, Terrain.outside, "terrain does not match")
    }

    func testTerrainTypePersisted() {
        
        // Preconditions
        let grid = Grid(width: 5, height: 5)
        
        // Stimulus
        let terrainBefore = Terrain.grass
        grid?.set(terrain: terrainBefore, at: GridPoint(x: 2, y: 2))
        
        // Assertion
        let terrainAfter = grid?.terrain(at: GridPoint(x: 2, y: 2))
        XCTAssertEqual(terrainBefore, terrainAfter, "terrain types does not match")
    }
    
    func testScreenPoint() {
        
        // Preconditions
        let grid = Grid(width: 5, height: 5)
        
        // Stimulus
        let screenPoint = grid?.screenPoint(from: GridPoint(x: 2, y: 2))
        
        // Assertion
        XCTAssertEqual(screenPoint, CGPoint(x: 108, y: 124), "screen point does not match")
    }
    
    func testGridPoint() {
        
        // Preconditions
        let grid = Grid(width: 5, height: 5)
        
        // Stimulus
        let gridPoint0 = grid?.gridPoint(from: CGPoint(x: 108, y: 124))
        let gridPoint1 = grid?.gridPoint(from: CGPoint(x: 0, y: 0))
        
        // Assertion
        XCTAssertEqual(gridPoint0, GridPoint(x: 2, y: 2), "grid point does not match")
        XCTAssertEqual(gridPoint1, GridPoint(x: 0, y: 0), "grid point does not match")
    }

    func testAddFeatureSucceeds() {
    
        // Preconditions
        let grid = Grid(width: 5, height: 5)
        
        // Stimulus
        grid?.add(feature: Feature.hill, at: GridPoint(x: 2, y: 2))
        
        // Assertion
        let hasHill = grid?.has(feature: Feature.hill, at: GridPoint(x: 2, y: 2))
        XCTAssertEqual(hasHill, true, "feature should have been added")
    }
    
    func testRemoveFeatureSucceeds() {
        
        // Preconditions
        let grid = Grid(width: 5, height: 5)
        grid?.add(feature: Feature.hill, at: GridPoint(x: 2, y: 2))
        let hasHillBefore = grid?.has(feature: Feature.hill, at: GridPoint(x: 2, y: 2))
        
        // Stimulus
        grid?.remove(feature: Feature.hill, at: GridPoint(x: 2, y: 2))
        
        // Assertion
        let hasHillAfter = grid?.has(feature: Feature.hill, at: GridPoint(x: 2, y: 2))
        XCTAssertEqual(hasHillBefore, true, "feature should have been added")
        XCTAssertEqual(hasHillAfter, false, "feature should have been removed")
    }
}
