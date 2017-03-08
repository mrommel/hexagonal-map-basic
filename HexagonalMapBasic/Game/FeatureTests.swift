//
//  FeatureTests.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 08.03.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import XCTest
@testable import HexagonalMapBasic

class FeatureTests: XCTestCase {
    
    func testNoneImage() {
        
        // Preconditions
        let feature: Feature = .none
        
        // Stimulus
        let image = feature.image
        
        // Assertion
        XCTAssertEqual(image, "---", "wrong image for \(feature)")
    }
    
    func testRoadImage() {
        
        // Preconditions
        let feature: Feature = .forest
        
        // Stimulus
        let image = feature.image
        
        // Assertion
        XCTAssertEqual(image, "Forest", "wrong image for \(feature)")
    }
}
