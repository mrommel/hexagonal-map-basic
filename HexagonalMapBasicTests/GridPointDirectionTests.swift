//
//  GridPointDirectionTests.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 10.02.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import XCTest

class GridPointDirectionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testOpposite() {

        XCTAssertEqual(GridPointDirection.northEast.opposite(), GridPointDirection.southWest, "opposite does not match")
        XCTAssertEqual(GridPointDirection.southEast.opposite(), GridPointDirection.northWest, "opposite does not match")
        XCTAssertEqual(GridPointDirection.south.opposite(), GridPointDirection.north, "opposite does not match")
        XCTAssertEqual(GridPointDirection.southWest.opposite(), GridPointDirection.northEast, "opposite does not match")
        XCTAssertEqual(GridPointDirection.northWest.opposite(), GridPointDirection.southEast, "opposite does not match")
        XCTAssertEqual(GridPointDirection.north.opposite(), GridPointDirection.south, "opposite does not match")
    }
    
}
