//
//  GridPointDirection.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 10.02.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation

enum GridPointDirection {
    
    case northEast
    case southEast
    case south
    case southWest
    case northWest
    case north
 
    func opposite() -> GridPointDirection {
        switch self {
        case .northEast:
            return .southWest
        case .southEast:
            return .northWest
        case .south:
            return .north
        case .southWest:
            return .northEast
        case .northWest:
            return .southEast
        case .north:
            return .south
        }
    }
    
    func text() -> String {
        switch self {
        case .northEast:
            return "northEast"
        case .southEast:
            return "southEast"
        case .south:
            return "south"
        case .southWest:
            return "southWest"
        case .northWest:
            return "northWest"
        case .north:
            return "north"
        }
    }
}
