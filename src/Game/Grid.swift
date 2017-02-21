//
//  Grid.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 09.02.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation
import CoreGraphics


public class Grid {
    
    var tiles: Array2D<Tile>
    var width: Int
    var height: Int
    
    static let kHexagonWidth: Double = 72.0
    static let kHexagonHeight: Double = 62.0 // height = sqrt(3)/2 * width
    
    required public init?(width: Int, height: Int) {
        
        self.tiles = Array2D<Tile>(columns: width, rows: height)
        self.width = width
        self.height = height
        
        for x in 0..<width {
            for y in 0..<height {
                self.tiles[x, y] = Tile(withTerrain: Terrain.ocean)
            }
        }
    }
    
    func tile(at position: GridPoint) -> Tile {
        
        // check bounds
        guard self.has(gridPoint: position) else {
            return Tile(withTerrain: Terrain.outside)
        }
        
        return self.tiles[position]!
    }
    
    func add(feature: Feature, at position: GridPoint) {
        
        // check bounds
        guard self.has(gridPoint: position) else {
            return
        }
        
        let tile = self.tiles[position]
        tile?.features.append(feature)
    }
    
    func set(terrain: Terrain, at position: GridPoint) {
        
        // check bounds
        guard self.has(gridPoint: position) else {
            return
        }
        
        let tile = self.tiles[position]
        tile?.terrain = terrain
    }
    
    func terrain(at position: GridPoint) -> Terrain {
        
        // check bounds
        guard self.has(gridPoint: position) else {
            return Terrain.outside
        }
        
        // If we have a terrain, return it
        if let tile = self.tiles[position] {
            return tile.terrain!
        } else {
            return Terrain.outside
        }
    }
    
    func has(gridPoint: GridPoint) -> Bool {
        return gridPoint.x >= 0 && gridPoint.x < self.width && gridPoint.y >= 0 && gridPoint.y < self.height
    }
    
    /*!
     * maps point from the screen coordinate system to grid
     */
    func gridPoint(from screenPoint: CGPoint) -> GridPoint {

        let deltaWidth = Grid.kHexagonHeight / 2 //
        var ergy: Int = 0
        //var offseted = false
        
        // ry -= 10;
        let inputX = Double(screenPoint.x + 1)
        let inputY = Double(screenPoint.y + 1)
        
        // rough rastering
        let ergx: Int = Int(inputX / (Grid.kHexagonWidth * 3 / 4))
        if (even(number: ergx)) {
            // offseted = false
            ergy = Int(inputY / Grid.kHexagonHeight)
        } else {
            // offseted = true
            ergy = Int((inputY - deltaWidth) / Grid.kHexagonHeight)
        }
        
        // fix errors
        /*var crossPoint: Double //X
        if offseted {
            crossPoint = Double(ergx) * (Grid.kHexagonWidth * 3 / 4) + deltaWidth
        } else {
            crossPoint = Double(ergx) * (Grid.kHexagonWidth * 3 / 4)
        }
        
        // error I
        //#warning the error is here
        var tmp = -(22.0 / 8.0) * (inputY - Double(ergy) * Grid.kHexagonHeight) + crossPoint
        
        if (((inputX - deltaWidth) < tmp) && (offseted))
        {
            ergy -= 1
        }
        if (((inputX - deltaWidth) < tmp) && (!offseted))
        {
            ergx -= 1
            ergy -= 1
        }
        
        // error II
        //#warning and here
        tmp = (22.0 / 8.0) * (inputY - Double(ergy) * Grid.kHexagonHeight) + crossPoint
        if (((inputX - deltaWidth) > tmp) && (offseted))
        {
            ergy -= 1
            ergx += 1
        }
        if (((inputX - deltaWidth) > tmp) && (!offseted))
        {
            ergy -= 1
        }*/
        
        // make it real
        return GridPoint(x: ergx, y: ergy)
    }
    
    func screenPoint(from gridPoint: GridPoint) -> CGPoint {
        
        return CGPoint(x: Double(gridPoint.x) * Grid.kHexagonWidth * 3 / 4,
                       y: Double(gridPoint.y) * Grid.kHexagonHeight + (even(number: Int(gridPoint.x)) ? 0 : Grid.kHexagonHeight / 2))
    }
    
}
