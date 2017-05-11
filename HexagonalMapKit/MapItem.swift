//
//  MapItem.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 22.02.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation

public class MapItem {
    
    let point: GridPoint
    
    public required init(at point: GridPoint) {
        self.point = point
    }
}
