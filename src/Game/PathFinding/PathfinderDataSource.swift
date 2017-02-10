//
//  PathfinderDataSource.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 10.02.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation

protocol PathfinderDataSource: NSObjectProtocol {
    func walkableAdjacentTilesCoordsForTileCoord(tileCoord: GridPoint) -> [GridPoint]
    func costToMoveFromTileCoord(fromTileCoord: GridPoint, toAdjacentTileCoord toTileCoord: GridPoint) -> Int
}
