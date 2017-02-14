//
//  Feature.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 14.02.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation

enum Feature {
    
    // misc
    case none
    
    // water terrain
    case island
    
    // solid terrain
    case forest
    case oasis
    
    var image: String {
        switch self {
        case .none:
            return "None"
        case .island:
            return "Island"
        case .forest:
            return "Forest"
        case .oasis:
            return "Oasis"
        }
    }
}
