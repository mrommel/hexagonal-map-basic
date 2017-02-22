//
//  Game.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 22.02.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation

class VictoryCondition {

    let name: String

    required init(withName name: String) {
        self.name = name
    }
}

class MapItem {

    let point: GridPoint

    required init(at point: GridPoint) {
        self.point = point
    }
}

class City: MapItem {

    var name: String

    required init(at point: GridPoint, of name: String) {

        self.name = name

        super.init(at: point)
    }

    required init(at point: GridPoint) {

        self.name = ""

        super.init(at: point)
    }
}

class Unit: MapItem {

}

enum TileImprovementType {

    case none

    case road

    case farm
    case pasture
    case plantation
    case lumbermill

    case mine
    case quarry

    var image: String {
        switch self {
        case .none:
            return "---"

        case .road:
            return "Road"

        case .farm:
            return "Farm"
        case .pasture:
            return "Pasture"
        case .plantation:
            return "Plantation"
        case .lumbermill:
            return "Lumbermill"

        case .mine:
            return "Mine"
        case .quarry:
            return "Quarry"
        }
    }
}

class TileImprovement: MapItem {

    let type: TileImprovementType

    required init(at point: GridPoint, of type: TileImprovementType) {

        self.type = type

        super.init(at: point)
    }

    required init(at point: GridPoint) {

        self.type = .none

        super.init(at: point)
    }
}

class Game {

    let name: String
    let text: String

    var map: Map? = nil
    var conditions: [VictoryCondition]? = nil

    required init(withName name: String, andText text: String) {
        self.name = name
        self.text = text
    }

}
