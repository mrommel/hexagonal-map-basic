//
//  Array2D.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 13.02.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation
import EVReflection

public class Array2D <T: Equatable>: EVObject {
    
    fileprivate var columns: Int = 1
    fileprivate var rows: Int = 1
    fileprivate var array: Array<T?> = Array<T?>()
    
    public init(columns: Int, rows: Int) {
        self.columns = columns
        self.rows = rows
        
        array = Array<T?>(repeating: nil, count: rows * columns)
    }
    
    required convenience public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required public init() {
        fatalError("init() has not been implemented")
    }
    
    public subscript(column: Int, row: Int) -> T? {
        get {
            return array[(row * columns) + column]
        }
        set(newValue) {
            array[(row * columns) + column] = newValue
        }
    }
    
    public func columnCount() -> Int {
        return columns
    }
    
    public func rowCount() -> Int {
        return rows
    }
}

public func == <T>(lhs: Array2D<T>, rhs: Array2D<T>) -> Bool {
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

// MARK: grid method

extension Array2D {
    
    public subscript(gridPoint: GridPoint) -> T? {
        get {
            return array[(gridPoint.y * columns) + gridPoint.x]
        }
        set(newValue) {
            array[(gridPoint.y * columns) + gridPoint.x] = newValue
        }
    }
    
}

extension Array2D {
    
    public func fill(with value: T) {
        
        for x in 0..<columns {
            for y in 0..<rows {
                self[x, y] = value
            }
        }
    }
}

extension Array2D: EVArrayConvertable {
    
    /**
     For implementing a function for converting a generic array to a specific array.
     */
    public func convertArray(_ key: String, array: Any) -> NSArray {
        
        assert(key == "array", "convertArray for key \(key) should be handled.")
        
        let returnArray = NSMutableArray()
        if key == "array" {
            for item in (array as? Array<T?>) ?? Array<T?>() {
                if let item = item {
                    returnArray.add(item)
                }
            }
        }
        return returnArray
    }
}
