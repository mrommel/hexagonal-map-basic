//
//  GridGenerator.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 13.02.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation

class GridGenerator {
    
    let width: Int
    let height: Int
    
    let terrain: Array2D<Terrain>
    
    required public init?(width: Int, height: Int) {
        
        self.width = width
        self.height = height
        
        self.terrain = Array2D<Terrain>(columns: self.width, rows: self.height)
        
        /*for x in 0..<width {
            for y in 0..<height {
                
            }
        }*/
    }
    
    func fill(with terrain: Terrain) {
        for x in 0..<width {
            for y in 0..<height {
                self.terrain[x, y] = terrain
            }
        }
    }
    
    func generate() -> Grid? {
        
        let grid = Grid(width: self.width, height: self.height)
        
        for x in 0..<width {
            for y in 0..<height {
                let gridPoint = GridPoint(x: x, y: y)
                let terrainVal = self.terrain[x, y]
                grid?.add(terrain: terrainVal!, at: gridPoint)
            }
        }
        
        return grid
    }
}

class HeightMap {
    
}
