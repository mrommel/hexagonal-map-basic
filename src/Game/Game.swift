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
