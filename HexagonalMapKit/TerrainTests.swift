//
//  TerrainTests.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 10.03.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import XCTest
@testable import HexagonalMapBasic

class TerrainTests: XCTestCase {
    
    func testOutsideImage() {
        
        // Preconditions
        let terrain: Terrain = .outside
        
        // Stimulus
        let image = terrain.image
        
        // Assertion
        XCTAssertEqual(image, "Outside", "wrong image for \(terrain)")
    }
}
