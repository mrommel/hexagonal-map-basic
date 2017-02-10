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
                XCTAssertEqual(terrain, Terrain.default, "terrain does not match")
            }
        }
    }

    func testTerrainTypePersisted() {
        
        let terrain0 = Terrain(terrainType: .grass)
        self.classUnderTest?.add(terrain: terrain0, at: GridPoint(x: 2, y: 2))
        
        let terrain1 = self.classUnderTest?.terrain(at: GridPoint(x: 2, y: 2))
        XCTAssertEqual(terrain1?.terrainType, terrain0.terrainType, "terrain types does not match")
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

}
