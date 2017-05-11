//
//  TileImprovementTypeTests.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 06.03.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import XCTest
@testable import HexagonalMapBasic

class TileImprovementTypeTests: XCTestCase {
    
    func testNoneImage() {
        
        // Preconditions
        let improvement: TileImprovementType = .none
        
        // Stimulus
        let image = improvement.image
        
        // Assertion
        XCTAssertEqual(image, "---", "wrong image for \(improvement)")
    }
    
    func testRoadImage() {
        
        // Preconditions
        let improvement: TileImprovementType = .road
        
        // Stimulus
        let image = improvement.image
        
        // Assertion
        XCTAssertEqual(image, "Road", "wrong image for \(improvement)")
    }
}
