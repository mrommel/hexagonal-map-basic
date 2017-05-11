//
//  Array2DTest.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 13.02.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import XCTest
@testable import HexagonalMapBasic

class Array2DTest: XCTestCase {
    
    func testEqualityNilValues() {
        let array1 = Array2D<Int>(columns: 3, rows: 3)
        let array2 = Array2D<Int>(columns: 3, rows: 3)
        
        XCTAssertEqual(array1, array2, "Arrays are equal with nil values : Should be equal")
    }
    
    func testEqualityEqualValues() {
        let array1 = Array2D<Int>(columns: 3, rows: 3)
        array1[0, 0] = 1
        array1[0, 1] = 2
        array1[0, 2] = 3
        array1[1, 0] = 4
        array1[1, 1] = 5
        array1[1, 2] = 6
        array1[2, 0] = 7
        array1[2, 1] = 8
        array1[2, 2] = 9
        
        let array2 = Array2D<Int>(columns: 3, rows: 3)
        array2[0, 0] = 1
        array2[0, 1] = 2
        array2[0, 2] = 3
        array2[1, 0] = 4
        array2[1, 1] = 5
        array2[1, 2] = 6
        array2[2, 0] = 7
        array2[2, 1] = 8
        array2[2, 2] = 9
        
        XCTAssertEqual(array1, array2, "Arrays are equal with equal values : Should be equal")
    }
    
    func testEqualityMixedNilValues() {
        let array1 = Array2D<Int>(columns: 3, rows: 3)
        array1[0, 0] = 1
        array1[0, 1] = 2
        array1[0, 2] = 3
        array1[2, 0] = 7
        array1[2, 1] = 8
        array1[2, 2] = 9
        
        let array2 = Array2D<Int>(columns: 3, rows: 3)
        array2[0, 0] = 1
        array2[0, 1] = 2
        array2[0, 2] = 3
        array2[2, 0] = 7
        array2[2, 1] = 8
        array2[2, 2] = 9
        
        XCTAssertEqual(array1, array2, "Arrays are equal with nil values : Should be equal")
    }
    
    func testEqualityDifferentRows() {
        let array1 = Array2D<Int>(columns: 3, rows: 3)
        let array2 = Array2D<Int>(columns: 3, rows: 4)
        
        XCTAssertNotEqual(array1, array2, "Arrays have different numbers of rows : Should not be equal")
    }
    
    func testEqualityDifferentColumns() {
        let array1 = Array2D<Int>(columns: 3, rows: 3)
        let array2 = Array2D<Int>(columns: 4, rows: 3)
        
        XCTAssertNotEqual(array1, array2, "Arrays have different numbers of columns : Should not be equal")
    }
    
    func testEqualityDifferentValues() {
        let array1 = Array2D<Int>(columns: 3, rows: 3)
        array1[0, 0] = 1
        
        let array2 = Array2D<Int>(columns: 3, rows: 3)
        array2[0, 0] = 2
        
        XCTAssertNotEqual(array1, array2, "Arrays are different with different values : Should not be equal")
    }
}

extension Array2DTest {
    
    func testSetValueWithPoint() {
        
        // Preconditions
        let array = Array2D<Int>(columns: 3, rows: 3)
        let pt = GridPoint(x: 1, y: 1)
        
        // Stimulus
        array[pt] = 1
        
        // Assertion
        XCTAssertEqual(array[pt], 1, "value not persisted")
    }
}
