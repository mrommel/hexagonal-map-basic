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
    
    var terrains: [GridPoint: Terrain] = [:]
    var width: Int
    var height: Int
    
    static let kHexagonWidth: Double = 72.0
    static let kHexagonHeight: Double = 62.0 // height = sqrt(3)/2 * width
    
    required public init?(width: Int, height: Int) {
        
        self.width = width
        self.height = height
        
        for x in 0..<width {
            for y in 0..<height {
                self.add(terrain: Terrain.default, at: GridPoint(x: x, y: y))
            }
        }
    }
    
    func add(terrain: Terrain, at position: GridPoint) {
        self.terrains[position] = terrain
    }
    
    func terrain(at position: GridPoint) -> Terrain {
        // If we have a terrain, return it
        if let terrain = self.terrains[position] {
            return terrain
        } else {
            return Terrain.default
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
        var offseted = false
        
        // ry -= 10;
        let inputX = Double(screenPoint.x + 1)
        let inputY = Double(screenPoint.y + 1)
        
        // rough rastering
        let ergx: Int = Int(inputX / (Grid.kHexagonWidth * 3 / 4))
        if (even(number: ergx))
        {
            offseted = false
            ergy = Int(inputY / Grid.kHexagonHeight)
        }
        else
        {
            offseted = true
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
