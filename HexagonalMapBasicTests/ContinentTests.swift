//
//  ContinentTests.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 06.03.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import XCTest

class ContinentTests: XCTestCase {
    
    func testContinentsSameAreEqual() {
        
        // Preconditions
        let map = Map(width: 5, height: 5)
        
        let boundary1 = AreaBoundary(topLeft: GridPoint(x: 0, y: 0), bottomRight: GridPoint(x: 2, y: 1))
        let continent1 = Continent(withIdentifier: 1, andName: "Europe", andBoundaries: boundary1, on: map)
        
        // Stimulus
        let areSame = continent1 == continent1
        
        // Assertion
        XCTAssertEqual(areSame, true, "same should be equal")
    }
    
    func testContinentsAreEqual() {
        
        // Preconditions
        let map = Map(width: 5, height: 5)
        
        let boundary1 = AreaBoundary(topLeft: GridPoint(x: 0, y: 0), bottomRight: GridPoint(x: 1, y: 1))
        let continent1 = Continent(withIdentifier: 1, andName: "Europe", andBoundaries: boundary1, on: map)
        
        let points = [GridPoint(x: 0, y: 0), GridPoint(x: 1, y: 0), GridPoint(x: 0, y: 1), GridPoint(x: 1, y: 1)]
        let continent2 = Continent(withIdentifier: 1, andName: "Europe", andPoints: points, on: map)
        
        // Stimulus
        let areSame = continent1 == continent2
        
        // Assertion
        XCTAssertEqual(areSame, true, "continents should be equal")
    }

    func testContinentsAreDifferentIdentifiers() {
        
        // Preconditions
        let map = Map(width: 5, height: 5)
        
        let boundary1 = AreaBoundary(topLeft: GridPoint(x: 0, y: 0), bottomRight: GridPoint(x: 1, y: 1))
        let continent1 = Continent(withIdentifier: 2, andName: "Europe", andBoundaries: boundary1, on: map)
        
        let boundary2 = AreaBoundary(topLeft: GridPoint(x: 0, y: 0), bottomRight: GridPoint(x: 1, y: 1))
        let continent2 = Continent(withIdentifier: 1, andName: "Europe", andBoundaries: boundary2, on: map)
        
        // Stimulus
        let areSame = continent1 == continent2
        
        // Assertion
        XCTAssertEqual(areSame, false, "continents should NOT be equal")
    }

    func testContinentsAreDifferentNames() {
        
        // Preconditions
        let map = Map(width: 5, height: 5)
        
        let boundary1 = AreaBoundary(topLeft: GridPoint(x: 0, y: 0), bottomRight: GridPoint(x: 1, y: 1))
        let continent1 = Continent(withIdentifier: 1, andName: "America", andBoundaries: boundary1, on: map)
        
        let boundary2 = AreaBoundary(topLeft: GridPoint(x: 0, y: 0), bottomRight: GridPoint(x: 1, y: 1))
        let continent2 = Continent(withIdentifier: 1, andName: "Europe", andBoundaries: boundary2, on: map)
        
        // Stimulus
        let areSame = continent1 == continent2
        
        // Assertion
        XCTAssertEqual(areSame, false, "continents should NOT be equal")
    }
    
    func testContinentsAreDifferentSizes() {
        
        // Preconditions
        let map = Map(width: 5, height: 5)
        
        let boundary1 = AreaBoundary(topLeft: GridPoint(x: 0, y: 0), bottomRight: GridPoint(x: 2, y: 1))
        let continent1 = Continent(withIdentifier: 1, andName: "Europe", andBoundaries: boundary1, on: map)
        
        let boundary2 = AreaBoundary(topLeft: GridPoint(x: 0, y: 0), bottomRight: GridPoint(x: 1, y: 1))
        let continent2 = Continent(withIdentifier: 1, andName: "Europe", andBoundaries: boundary2, on: map)
        
        // Stimulus
        let areSame = continent1 == continent2
        
        // Assertion
        XCTAssertEqual(areSame, false, "continents should NOT be equal")
    }
}
