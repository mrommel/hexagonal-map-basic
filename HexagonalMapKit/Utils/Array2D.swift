//
//  Array2D.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 13.02.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation
import JSONCodable

extension JSONTransformers {
    
    static let JSONObjectType = JSONTransformer<JSONObject, JSONObject>(
        decoding: { $0 },
        encoding: { $0 })
    
    static let JSONObjectArray = JSONTransformer<[JSONObject], [JSONObject]>(
        decoding: { $0 },
        encoding: { $0 })
}

public class TileArray: Array2D<Tile>, JSONCodable {
    
    public required override init(columns: Int, rows: Int) {
        super.init(columns: columns, rows: rows)
    }
    
    public required init(object: JSONObject) throws {
        let decoder = JSONDecoder(object: object)
        
        let rowValue: Int = try decoder.decode("rows")
        let columnsValue: Int = try decoder.decode("columns")
        
        super.init(columns: columnsValue, rows: rowValue)
        
        let arrayValues: [JSONObject] = try decoder.decode("array", transformer: JSONTransformers.JSONObjectArray)
        
        for x in 0..<columns {
            for y in 0..<rows {
                do {
                    let json = arrayValues[((y * columns) + x)]
                    let tile = try Tile(object: json)
                    self[x, y] = tile
                } catch let error as JSONDecodableError {
                    print("Error during \((y * columns) + x) Tile parsing: \(error)")
                    self[x, y] = Tile(at: GridPoint(x: x, y: y), withTerrain: .ocean)
                }
            }
        }
    }
}

public class Array2D <T: Equatable> {
    
    fileprivate var columns: Int = 0
    fileprivate var rows: Int = 0
    fileprivate var array: Array<T?> = Array<T?>()
    
    public init(columns: Int, rows: Int) {
        self.columns = columns
        self.rows = rows
        
        self.array = Array<T?>(repeating: nil, count: rows * columns)
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

/// MARK: Equatable

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
