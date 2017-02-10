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
    case east
    case southEast
    case southWest
    case west
    case northWest
 
    func opposite() -> GridPointDirection {
        switch self {
        case .northEast:
            return .southWest
        case .east:
            return .west
        case .southEast:
            return .northWest
        case .southWest:
            return .northEast
        case .west:
            return .east
        case .northWest:
            return .southEast
        }
    }
    
    func text() -> String {
        switch self {
        case .northEast:
            return "northEast"
        case .east:
            return "east"
        case .southEast:
            return "southEast"
        case .southWest:
            return "southWest"
        case .west:
            return "west"
        case .northWest:
            return "northWest"
        }
    }
}
