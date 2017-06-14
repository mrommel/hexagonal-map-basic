//
//  MapItem.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 22.02.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation
import JSONCodable

public class MapItem: JSONCodable  {
    
    var point: GridPoint
    
    public convenience init() {
        self.init(at: GridPoint(x: 0, y: 0))
    }
    
    public required init(at point: GridPoint) {
        self.point = point
    }
    
    public required init(object: JSONObject) throws {
        let decoder = JSONDecoder(object: object)
        
        self.point = try decoder.decode("point")
    }
}
