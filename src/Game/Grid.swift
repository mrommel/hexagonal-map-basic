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
    
    let kHexagonWidth: Double = 140.0
    let kHexagonHeight: Double = 120.0
    
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
    
    /*!
     * maps point from the screen coordinate system to grid
     */
    func gridPoint(from screenPoint: CGPoint) -> GridPoint {

        let deltaWidth = (kHexagonWidth * 3 / 4) / 2
        var ergx: Int = 0
        var moved = false
        
        // ry -= 10;
        let inputX = Double(screenPoint.x)
        let inputY = Double(screenPoint.y) - 10
        
        // rough rastering
        var ergy: Int = Int(inputY / kHexagonHeight)
        if (ergy % 2 == 1)
        {
            moved = false
            ergx = Int(inputX / (kHexagonWidth * 3 / 4))
        }
        else
        {
            moved = true
            ergx = Int((inputX - deltaWidth) / (kHexagonWidth * 3 / 4))
        }
        
        // fix errors
        var crossPoint: Double //X
        if moved {
            crossPoint = Double(ergx) * (kHexagonWidth * 3 / 4) + deltaWidth
        } else {
            crossPoint = Double(ergx) * (kHexagonWidth * 3 / 4)
        }
        
        // error I
        //#warning the error is here
        var tmp = -(22.0 / 8.0) * (inputY - Double(ergy) * kHexagonHeight) + crossPoint
        
        if (((inputX - deltaWidth) < tmp) && (moved))
        {
            ergy -= 1
        }
        if (((inputX - deltaWidth) < tmp) && (!moved))
        {
            ergx -= 1
            ergy -= 1
        }
        
        // error II
        //#warning and here
        tmp = (22.0 / 8.0) * (inputY - Double(ergy) * kHexagonHeight) + crossPoint
        if (((inputX - deltaWidth) > tmp) && (moved))
        {
            ergy -= 1
            ergx += 1
        }
        if (((inputX - deltaWidth) > tmp) && (!moved))
        {
            ergy -= 1
        }
        
        // make it real
        return GridPoint(x: ergx, y: ergy)
    }
    
    func screenPoint(from gridPoint: GridPoint) -> CGPoint {
        
        return CGPoint(x: Double(gridPoint.x) * kHexagonWidth * 3 / 4, y: Double(gridPoint.y) * kHexagonHeight + (even(number: Int(gridPoint.x)) ? 0 : kHexagonHeight / 2))
    }
    
}
