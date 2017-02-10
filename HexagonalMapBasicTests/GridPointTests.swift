//
//  GridPointTests.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 10.02.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import XCTest

class GridPointTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testOppositeOddColumn() {
        
        XCTAssertEqual(GridPoint(x: 1, y: 1).neighbor(in: .northEast), GridPoint(x: 2, y: 1), "neighbor does not match")
        XCTAssertEqual(GridPoint(x: 1, y: 1).neighbor(in: .southEast), GridPoint(x: 2, y: 2), "neighbor does not match")
        XCTAssertEqual(GridPoint(x: 1, y: 1).neighbor(in: .south), GridPoint(x: 1, y: 2), "neighbor does not match")
        XCTAssertEqual(GridPoint(x: 1, y: 1).neighbor(in: .southWest), GridPoint(x: 0, y: 2), "neighbor does not match")
        XCTAssertEqual(GridPoint(x: 1, y: 1).neighbor(in: .northWest), GridPoint(x: 0, y: 1), "neighbor does not match")
        XCTAssertEqual(GridPoint(x: 1, y: 1).neighbor(in: .north), GridPoint(x: 1, y: 0), "neighbor does not match")
    }
    
    func testOppositeEvenColumn() {
        
        XCTAssertEqual(GridPoint(x: 2, y: 2).neighbor(in: .northEast), GridPoint(x: 3, y: 1), "neighbor does not match")
        XCTAssertEqual(GridPoint(x: 2, y: 2).neighbor(in: .southEast), GridPoint(x: 3, y: 2), "neighbor does not match")
        XCTAssertEqual(GridPoint(x: 2, y: 2).neighbor(in: .south), GridPoint(x: 2, y: 3), "neighbor does not match")
        XCTAssertEqual(GridPoint(x: 2, y: 2).neighbor(in: .southWest), GridPoint(x: 1, y: 2), "neighbor does not match")
        XCTAssertEqual(GridPoint(x: 2, y: 2).neighbor(in: .northWest), GridPoint(x: 1, y: 1), "neighbor does not match")
        XCTAssertEqual(GridPoint(x: 2, y: 2).neighbor(in: .north), GridPoint(x: 2, y: 1), "neighbor does not match")
    }
}
