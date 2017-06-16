//
//  Continent.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 06.03.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation
import JSONCodable

public class Continent: Area {
    
    public var name: String
    
    public init(withIdentifier identifier: Int, andName name: String, andBoundaries boundary: AreaBoundary, on map: Map) {
        self.name = name
        super.init(withIdentifier: identifier, andBoundaries: boundary, on: map)
    }
    
    public init(withIdentifier identifier: Int, andName name: String, andPoints points: [GridPoint]?, on map: Map) {
        self.name = name
        super.init(withIdentifier: identifier, andPoints: points, on: map)
    }
    
    public required init(object: JSONObject) throws {
        let decoder = JSONDecoder(object: object)
        
        self.name = try decoder.decode("name")
        
        // Area fields
        self.identifier = try decoder.decode("identifier")
        self.points = try decoder.decode("points")
        self.statistics = try decoder.decode("statistics")
    }
    
    public func toJSON() throws -> Any {
        return try JSONEncoder.create({ (encoder) -> Void in
            try encoder.encode(self.name, key: "name")
            
            // Area fields
            try encoder.encode(self.identifier, key: "identifier")
            try encoder.encode(self.points, key: "points")
            try encoder.encode(self.statistics, key: "statistics")           
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
