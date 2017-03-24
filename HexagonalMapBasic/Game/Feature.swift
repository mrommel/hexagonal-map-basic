//
//  Feature.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 14.02.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation

public enum Feature: String {
    
    // misc
    case none
    
    // water terrain
    case island = "i"
    
    // solid terrain
    case forest = "f"
    case swamp = "s"
    case hill = "h"
    case mountain = "m"
    
    // tile matching
    case matchesAny = "*"
    case matchesNoHill = "nh"
    
    var image: String {
        switch self {
        case .island:
            return "Island"
        case .forest:
            return "Forest"
        case .hill:
            return "Hill"
        case .mountain:
            return "Mountain"
        default:
            return "---"
        }
    }
}
