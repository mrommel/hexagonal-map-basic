//
//  City.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 22.02.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation

class City: MapItem {
    
    var name: String
    var map: Map? = nil
    
    required init(at point: GridPoint, of name: String) {
        
        self.name = name
        
        super.init(at: point)
    }
    
    required init(at point: GridPoint) {
        
        self.name = ""
        
        super.init(at: point)
    }
}
