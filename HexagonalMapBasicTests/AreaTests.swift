//
//  AreaTests.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 01.03.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import XCTest

class AreaTests: XCTestCase {
    
    func testCoastalCountIsZero() {
        
        // Preconditions
        let map = Map(width: 5, height: 5)
        
        let areaBoundary = AreaBoundary(topLeft: GridPoint(x: 1, y: 1), bottomRight: GridPoint(x: 3, y: 3))
        let area = Area(withBoundaries: areaBoundary, on: map)
        
        // Stimulus
        area.update()
        
        // Assertion
        XCTAssertEqual(area.statistics.coastTiles, 0, "coastal count should be zero")
    }
    
    func testCoastalCountWithOutsideLand() {
        
        // Preconditions
        let map = Map(width: 5, height: 5)
        map.grid?.set(terrain: .grass, at: GridPoint(x: 0, y: 1))
        
        let areaBoundary = AreaBoundary(topLeft: GridPoint(x: 1, y: 1), bottomRight: GridPoint(x: 3, y: 3))
        let area = Area(withBoundaries: areaBoundary, on: map)
        
        // Stimulus
        area.update()
        
        // Assertion
        XCTAssertEqual(area.statistics.coastTiles, 1, "coastal count should be 1")
    }
    
    func testCoastalCountWithInsideLand() {
        
        // Preconditions
        let map = Map(width: 5, height: 5)
        map.grid?.set(terrain: .grass, at: GridPoint(x: 2, y: 1))
        
        let areaBoundary = AreaBoundary(topLeft: GridPoint(x: 1, y: 1), bottomRight: GridPoint(x: 3, y: 3))
        let area = Area(withBoundaries: areaBoundary, on: map)
        
        // Stimulus
        area.update()
        
        // Assertion
        XCTAssertEqual(area.statistics.coastTiles, 3, "coastal count should be 3")
    }
}
