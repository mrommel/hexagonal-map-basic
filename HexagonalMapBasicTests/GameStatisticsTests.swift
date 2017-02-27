//
//  GameStatisticsTests.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 24.02.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import XCTest

class GameStatisticsTests: XCTestCase {
    
    func testCalculateDiscoveredTiles() {
        
        // Preconditions
        let game = Game(withName: "test", andText: "test")
        game.map = Map(width: 5, height: 5)
        game.map?.discover(at: GridPoint(x: 1, y: 1), by: Player.human)
        game.map?.discover(at: GridPoint(x: 2, y: 1), by: Player.human)
        game.map?.discover(at: GridPoint(x: 1, y: 2), by: Player.human)
        
        // Stimulus
        let gameStatistics = game.extractStatistics()
        
        // Assertion
        XCTAssertEqual(gameStatistics.discoveredTiles, 3, "discovered tiles number does not match")
    }
}
