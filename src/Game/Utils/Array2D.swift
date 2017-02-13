//
//  Array2D.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 13.02.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation

class Array2D<T: Equatable>: Equatable {
    
    private let columns: Int
    private let rows: Int
    fileprivate var array: Array<T?>
    
    init(columns: Int, rows: Int) {
        self.columns = columns;
        self.rows = rows;
        
        array = Array<T?>(repeating: nil, count: rows * columns)
    }
    
    subscript(column: Int, row: Int) -> T? {
        get {
            return array[(row * columns) + column]
        }
        set(newValue) {
            array[(row * columns) + column] = newValue
        }
    }
    
    func columnCount() -> Int {
        return columns
    }
    
    func rowCount() -> Int {
        return rows
    }
}

func ==<T>(lhs: Array2D<T>, rhs: Array2D<T>) -> Bool {
    if lhs.array.count != rhs.array.count {
        return false
    }
    
    for x in 0..<lhs.columnCount() {
        for y in 0..<lhs.rowCount() {
            if lhs[x, y] != rhs[x, y] {
                return false
            }
        }
    }
    
    return true
}
