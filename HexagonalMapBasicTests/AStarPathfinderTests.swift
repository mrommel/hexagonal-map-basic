//
//  AStarPathfinderTests.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 10.02.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import XCTest

class AStarPathfinderTests: XCTestCase {
    
    private class AStarPathfinderData: NSObject, PathfinderDataSource {
        
        var grid: Grid?
        
        func walkableAdjacentTilesCoordsForTileCoord(tileCoord: GridPoint) -> [GridPoint] {
            var walkableCoords = [GridPoint]()
            
            if let grid = self.grid {
                for neighbor in tileCoord.neighbors() {
                    if grid.has(gridPoint: neighbor) {
                        walkableCoords.append(neighbor)
                    }
                }
            }
            
            return walkableCoords
        }
        func costToMoveFromTileCoord(fromTileCoord: GridPoint, toAdjacentTileCoord toTileCoord: GridPoint) -> Int{
            return 1
        }
    }
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFindPath() {
        
        let pathfinder = AStarPathfinder()
        let grid = Grid(width: 5, height: 5)
        let dataSource = AStarPathfinderData()
        dataSource.grid = grid
        pathfinder.dataSource = dataSource
        
        let path = pathfinder.shortestPathFromTileCoord(fromTileCoord: GridPoint(x: 0, y: 0), toTileCoord: GridPoint(x: 3, y: 2))
        
        XCTAssertEqual(path?.count, 4, "path has wrong length")
        XCTAssertEqual(path?[0], GridPoint(x: 1, y: 0), "first point does not match")
        XCTAssertEqual(path?[1], GridPoint(x: 2, y: 1), "first point does not match")
        XCTAssertEqual(path?[2], GridPoint(x: 2, y: 2), "first point does not match")
        XCTAssertEqual(path?[3], GridPoint(x: 3, y: 2), "first point does not match")
    }
}
