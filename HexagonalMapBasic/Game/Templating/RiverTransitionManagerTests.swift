//
//  RiverTransitionManagerTests.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 10.03.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import XCTest
@testable import HexagonalMapBasic

class RiverTransitionManagerTests: XCTestCase {
    
    func testTransitionInNorth() {
        
        // Preconditions
        let riverTransitionManager = RiverTransitionManager()
        
        // Stimulus
        let transitions = riverTransitionManager.bestTransitions(forCenter: [.east], remotesNE: [] /* never */, remotesSE: [], remotesS: [], remotesSW: [], remotesNW: [], remotesN: [.southWest])
        
        // Assertion
        XCTAssertEqual(transitions?.count, 1, "there should be only one transition")
        
        if (transitions?.count)! >= 1 {
            XCTAssertEqual(transitions?[0].image, "River-4", "wrong transition")
        }
    }
    
    func testOneInternalTransitions() {
        
        // Preconditions
        let riverTransitionManager = RiverTransitionManager()
        
        // Stimulus
        let transitions = riverTransitionManager.bestTransitions(forCenter: [.west, .northWest], remotesNE: [] /* never */, remotesSE: [], remotesS: [], remotesSW: [], remotesNW: [], remotesN: [])
        
        // Assertion
        XCTAssertEqual(transitions?.count, 1, "there should be two internal transitions")
        
        let images = transitions?.map( { $0.image } )
        XCTAssertTrue((images?.contains(where: { $0 == "River-1" }))!, "should contain River-1")
    }
    
    func testTwoInternalTransitions() {
        
        // Preconditions
        let riverTransitionManager = RiverTransitionManager()
        
        // Stimulus
        let transitions = riverTransitionManager.bestTransitions(forCenter: [.west, .northWest, .northEast], remotesNE: [] /* never */, remotesSE: [], remotesS: [], remotesSW: [], remotesNW: [], remotesN: [])
        
        // Assertion
        XCTAssertEqual(transitions?.count, 2, "there should be two internal transitions")
        
        let images = transitions?.map( { $0.image } )
        XCTAssertTrue((images?.contains(where: { $0 == "River-1" }))!, "should contain River-1")
        XCTAssertTrue((images?.contains(where: { $0 == "River-7" }))!, "should contain River-7")
    }
}
