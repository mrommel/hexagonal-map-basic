//
//  FeatureTransitionManagerTests.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 08.03.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import XCTest
@testable import HexagonalMapBasic

class FeatureTransitionManagerTests: XCTestCase {
    
    func testOutside() {
        
        // Preconditions
        let featureTransitionManager = FeatureTransitionManager()
        
        // Stimulus
        let transitions = featureTransitionManager.bestTransitions(forCenter: [], remotesNE: [.hill], remotesSE: [], remotesS: [], remotesSW: [], remotesNW: [], remotesN: [])
        
        // Assertion
        XCTAssertEqual(transitions?.count, 1, "there should be only one transition")
        XCTAssertEqual(transitions?[0].image, "Hill-se", "wrong first transition")

    }
}
