//
//  GridTests.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 09.02.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import XCTest

class GridTests: XCTestCase {
    
    var classUnderTest: Grid?
    
    override func setUp() {
        super.setUp()
        
        self.classUnderTest = Grid(width: 5, height: 5)
    }
    
    override func tearDown() {
        
        self.classUnderTest = nil
        
        super.tearDown()
    }
    
    func testDefaultInit() {

        for x in 0..<5 {
            for y in 0..<5 {
                let terrain = self.classUnderTest?.terrain(at: GridPoint(x: x, y: y))
                XCTAssertEqual(terrain, Terrain.ocean, "terrain does not match")
            }
        }
    }
    
    func testOutside() {
        let terrain = self.classUnderTest?.terrain(at: GridPoint(x: -1, y: -1))
        XCTAssertEqual(terrain, Terrain.outside, "terrain does not match")
    }

    func testTerrainTypePersisted() {
        
        let terrain0 = Terrain.grass
        self.classUnderTest?.set(terrain: terrain0, at: GridPoint(x: 2, y: 2))
        
        let terrain1 = self.classUnderTest?.terrain(at: GridPoint(x: 2, y: 2))
        XCTAssertEqual(terrain1, terrain0, "terrain types does not match")
    }
    
    func testScreenPoint() {
        
        let screenPoint = self.classUnderTest?.screenPoint(from: GridPoint(x: 2, y: 2))
        XCTAssertEqual(screenPoint, CGPoint(x: 108, y: 124), "screen point does not match")
    }
    
    func testGridPoint() {
        
        let gridPoint = self.classUnderTest?.gridPoint(from: CGPoint(x: 108, y: 124))
        XCTAssertEqual(gridPoint, GridPoint(x: 2, y: 2), "grid point does not match")
        
        
        let gridPoint1 = self.classUnderTest?.gridPoint(from: CGPoint(x: 0, y: 0))
        XCTAssertEqual(gridPoint1, GridPoint(x: 0, y: 0), "grid point does not match")
    }

    func testAddFeatureSucceeds() {
    
        // Preconditions
        
        // Stimulus
        self.classUnderTest?.add(feature: Feature.hill, at: GridPoint(x: 2, y: 2))
        
        // Assertion
        let hasHill = self.classUnderTest?.has(feature: Feature.hill, at: GridPoint(x: 2, y: 2))
        XCTAssertEqual(hasHill, true, "feature should have been added")
    }
    
    func testRemoveFeatureSucceeds() {
        
        // Preconditions
        self.classUnderTest?.add(feature: Feature.hill, at: GridPoint(x: 2, y: 2))
        let hasHillBefore = self.classUnderTest?.has(feature: Feature.hill, at: GridPoint(x: 2, y: 2))
        
        // Stimulus
        self.classUnderTest?.remove(feature: Feature.hill, at: GridPoint(x: 2, y: 2))
        
        // Assertion
        let hasHillAfter = self.classUnderTest?.has(feature: Feature.hill, at: GridPoint(x: 2, y: 2))
        XCTAssertEqual(hasHillBefore, true, "feature should have been added")
        XCTAssertEqual(hasHillAfter, false, "feature should have been removed")
    }
}
