//
//  Continent.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 06.03.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation
import JSONCodable

public class Continent: Area, JSONCodable {
    
    public var name: String
    
    public init(withIdentifier identifier: Int, andName name: String, andBoundaries boundary: AreaBoundary, on map: Map?) {
        self.name = name
        super.init(withIdentifier: identifier, andBoundaries: boundary, on: map)
    }
    
    public init(withIdentifier identifier: Int, andName name: String, andPoints points: [GridPoint]?, on map: Map?) {
        self.name = name
        super.init(withIdentifier: identifier, andPoints: points, on: map)
    }
    
    public required init(object: JSONObject) throws {
        let decoder = JSONDecoder(object: object)
        
        self.name = try decoder.decode("name")
        
        // Area fields
        let id: Int = try decoder.decode("identifier")
        let pts: [GridPoint] = try decoder.decode("points")
        super.init(withIdentifier: id, andPoints: pts, on: nil)
    }
    
    public func toJSON() throws -> Any {
        return try JSONEncoder.create({ (encoder) -> Void in
            try encoder.encode(self.name, key: "name")
            
            // Area fields
            try encoder.encode(self.identifier, key: "identifier")
            try encoder.encode(self.points, key: "points")
            print("endode continent: \(self.name)")
        })
    }
}

func == (lhs: Continent, rhs: Continent) -> Bool {
    return lhs.identifier == rhs.identifier &&
        lhs.name == rhs.name &&
        lhs.size() == rhs.size() &&
        lhs.contains(points: rhs.points!) &&
        rhs.contains(points: lhs.points!)
}
