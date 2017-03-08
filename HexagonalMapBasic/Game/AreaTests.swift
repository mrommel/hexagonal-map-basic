//
//  AreaTests.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 01.03.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import XCTest
@testable import HexagonalMapBasic

class AreaTests: XCTestCase {
    
    func testAreaBoundarySize() {
        
        // Preconditions
        let areaBoundary = AreaBoundary(topLeft: GridPoint(x: 1, y: 1), bottomRight: GridPoint(x: 3, y: 3))
        
        // Stimulus
        let size = areaBoundary.size()
        
        // Assertion
        XCTAssertEqual(size, 9, "boundary size is not correct")
    }
    
    func testCoastalCountWithOutsideTerrain() {
        
        // Preconditions
        let map = Map(width: 5, height: 5)
        map.grid?.set(terrain: .outside, at: GridPoint(x: 0, y: 1))
        
        let areaBoundary = AreaBoundary(topLeft: GridPoint(x: 1, y: 1), bottomRight: GridPoint(x: 3, y: 3))
        let area = Area(withIdentifier: 1, andBoundaries: areaBoundary, on: map)
        
        // Stimulus
        area.update()
        
        // Assertion
        XCTAssertEqual(area.statistics.coastTiles, 0, "coastal count should be zero")
    }
    
    func testCoastalCountWithOutsideBoundaries() {
        
        // Preconditions
        let map = Map(width: 5, height: 5)

        let areaBoundary = AreaBoundary(topLeft: GridPoint(x: -1, y: -1), bottomRight: GridPoint(x: 3, y: 3))
        let area = Area(withIdentifier: 1, andBoundaries: areaBoundary, on: map)
        
        // Stimulus
        area.update()
        
        // Assertion
        XCTAssertEqual(area.statistics.coastTiles, 0, "coastal count should be zero")
    }
    
    func testCoastalCountIsZero() {
        
        // Preconditions
        let map = Map(width: 5, height: 5)
        
        let areaBoundary = AreaBoundary(topLeft: GridPoint(x: 1, y: 1), bottomRight: GridPoint(x: 3, y: 3))
        let area = Area(withIdentifier: 1, andBoundaries: areaBoundary, on: map)
        
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
        let area = Area(withIdentifier: 1, andBoundaries: areaBoundary, on: map)
        
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
        let area = Area(withIdentifier: 1, andBoundaries: areaBoundary, on: map)
        
        // Stimulus
        area.update()
        
        // Assertion
        XCTAssertEqual(area.statistics.coastTiles, 3, "coastal count should be 3")
    }
    
    func testSizeForBoundaryConstruction() {
        
        // Preconditions
        let map = Map(width: 5, height: 5)
        
        let areaBoundary = AreaBoundary(topLeft: GridPoint(x: 1, y: 1), bottomRight: GridPoint(x: 3, y: 3))
        let area = Area(withIdentifier: 1, andBoundaries: areaBoundary, on: map)
        
        // Stimulus
        let size = area.size()
        
        // Assertion
        XCTAssertEqual(size, 9, "size should be 9")
    }
    
    func testSizeForPointsConstruction() {
        
        // Preconditions
        let map = Map(width: 5, height: 5)
        
        let points = [GridPoint(x: 1, y: 1), GridPoint(x: 2, y: 1), GridPoint(x: 1, y: 3)]
        let area = Area(withIdentifier: 1, andPoints: points, on: map)
        
        // Stimulus
        let size = area.size()
        
        // Assertion
        XCTAssertEqual(size, 3, "size should be 3")
    }
    
    func testContainsWithSelf() {
        
        // Preconditions
        let map = Map(width: 5, height: 5)
        
        let points = [GridPoint(x: 1, y: 1), GridPoint(x: 2, y: 1), GridPoint(x: 1, y: 3)]
        let area = Area(withIdentifier: 1, andPoints: points, on: map)
        
        // Stimulus
        let contains = area.contains(points: area.points!)
        
        // Assertion
        XCTAssertEqual(contains, true, "area should contain itself")
    }
    
    func testContainsWithSmallerArea() {
        
        // Preconditions
        let map = Map(width: 5, height: 5)
        
        let points = [GridPoint(x: 1, y: 1), GridPoint(x: 2, y: 1), GridPoint(x: 1, y: 3)]
        let area = Area(withIdentifier: 1, andPoints: points, on: map)
        
        // Stimulus
        let contains = area.contains(points: [GridPoint(x: 1, y: 1), GridPoint(x: 1, y: 3)])
        
        // Assertion
        XCTAssertEqual(contains, true, "area should contain smaller area")
    }
    
    func testContainsWithBiggerArea() {
        
        // Preconditions
        let map = Map(width: 5, height: 5)
        
        let points = [GridPoint(x: 1, y: 1), GridPoint(x: 2, y: 1), GridPoint(x: 1, y: 3)]
        let area = Area(withIdentifier: 1, andPoints: points, on: map)
        
        // Stimulus
        let contains = area.contains(points: [GridPoint(x: 1, y: 1), GridPoint(x: 1, y: 3), GridPoint(x: 4, y: 3)])
        
        // Assertion
        XCTAssertEqual(contains, false, "area should NOT contain bigger area")
    }
}
