//
//  MapItem.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 22.02.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation

class MapItem {
    
    let point: GridPoint
    
    required init(at point: GridPoint) {
        self.point = point
    }
}
