//
//  Grid.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 09.02.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation
import CoreGraphics
import JSONCodable

/**
    Matrix of `Tile`s
 
    This class provides functions to manipulate the tiles (add/remove features, set terrain, etc)
    Used by `Map`to hold all the references to the `Tile`s
 */
public class Grid: JSONCodable {
    
    public var tiles: TileArray = TileArray(columns: 1, rows: 1)
    public var width: Int = 0
    public var height: Int = 0
    public var rivers: [River?] = []
    
    public static let kHexagonWidth: Double = 72.0
    public static let kHexagonHeight: Double = 62.0 // height = sqrt(3)/2 * width
    
    /**
        Create a Grid with `width`x`height`dimensions
     
        ```
        let grid = Grid(width: 2, height: 3)
        ```
     
        - Parameter width: width of the map
        - Parameter height: height of the map
     */
    public required init?(width: Int, height: Int) {
        
        self.tiles = TileArray(columns: width, rows: height)
        self.width = width
        self.height = height
        self.rivers = []
        
        for x in 0..<width {
            for y in 0..<height {
                self.tiles[x, y] = Tile(at: GridPoint(x: x, y: y), withTerrain: Terrain.ocean)
            }
        }
    }
    
    public required init(object: JSONObject) throws {
        let decoder = JSONDecoder(object: object)
        
        self.tiles = try decoder.decode("tiles")
        self.width = try decoder.decode("width")
        self.height = try decoder.decode("height")
        self.rivers = try decoder.decode("rivers")
        
        print("decoded Grid")
    }
    
    /**
        Getter for `Tile` at `position`
     
        - Parameter position: location in the grid to return the `Tile`
        
        - Returns: `Tile` at `position`
     */
    public func tile(at position: GridPoint) -> Tile {
        
        // check bounds
        guard self.has(gridPoint: position) else {
            return Tile(at: position, withTerrain: Terrain.outside)
        }
        
        return self.tiles[position]!
    }
    
    public func tileAt(x: Int, y: Int) -> Tile {
        
        return tile(at: GridPoint(x: x, y: y))
    }
    
    public func set(terrain: Terrain, at position: GridPoint) {
        
        // check bounds
        guard self.has(gridPoint: position) else {
            return
        }
        
        let tile = self.tiles[position]
        tile?.terrain = terrain
    }
    
    public func terrain(at position: GridPoint) -> Terrain {
        
        // check bounds
        guard self.has(gridPoint: position) else {
            return Terrain.outside
        }
        
        // If we have a terrain, return it
        if let tile = self.tiles[position] {
            return tile.terrain
        } else {
            return Terrain.outside
        }
    }
    
    public func terrainAt(x: Int, y: Int) -> Terrain {
        
        // check bounds
        guard self.hasAt(x: x, y: y) else {
            return Terrain.outside
        }
        
        // If we have a terrain, return it
        if let tile = self.tiles[x, y] {
            return tile.terrain
        } else {
            return Terrain.outside
        }
    }
    
    public func has(gridPoint: GridPoint) -> Bool {
        return gridPoint.x >= 0 && gridPoint.x < self.width && gridPoint.y >= 0 && gridPoint.y < self.height
    }
    
    public func hasAt(x: Int, y: Int) -> Bool {
        return x >= 0 && x < self.width && y >= 0 && y < self.height
    }
    
    public func isWater(at position: GridPoint) -> Bool {
        return self.terrain(at: position).isWater
    }
    
    public func isGround(at position: GridPoint) -> Bool {
        return self.terrain(at: position).isGround
    }
    
    public func isCoastal(at position: GridPoint) -> Bool {
        
        let centerTerrain = self.terrain(at: position)
        
        if !centerTerrain.isWater {
            return false
        }
        
        for neighbor in position.neighbors() {
            let neighborTerrain = self.terrain(at: neighbor)
            
            if neighborTerrain.isGround {
                return true
            }
        }
        
        return false
    }
    
    public func isCoastalAt(x: Int, y: Int) -> Bool {
        return self.isCoastal(at: GridPoint(x: x, y: y))
    }
    
    public func isNextToOcean(at position: GridPoint) -> Bool {
        
        let centerTerrain = self.terrain(at: position)
        
        if !centerTerrain.isGround {
            return false
        }
        
        for neighbor in position.neighbors() {
            let neighborTerrain = self.terrain(at: neighbor)
            
            if neighborTerrain.isWater {
                return true
            }
        }
        
        return false
    }
    
    /*!
     * maps point from the screen coordinate system to grid
     */
    public func gridPoint(from screenPoint: CGPoint) -> GridPoint {

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
    
    public func screenPoint(from gridPoint: GridPoint) -> CGPoint {
        
        return gridPoint.screenPoint()
    }
    
}

// MARK: feature related methods

extension Grid {
    
    public func has(feature: Feature, at position: GridPoint) -> Bool {
        
        // check bounds
        guard self.has(gridPoint: position) else {
            return false
        }
        
        let tile = self.tiles[position]
        for featureAtTile in (tile?.features)! {
            if featureAtTile == feature {
                return true
            }
        }
        
        return false
    }
    
    public func add(feature: Feature, at position: GridPoint) {
        
        // check bounds
        guard self.has(gridPoint: position) else {
            return
        }
        
        let tile = self.tiles[position]
        tile?.set(feature: feature)
    }
    
    public func remove(feature: Feature, at position: GridPoint) {
        
        // check bounds
        guard self.has(gridPoint: position) else {
            return
        }
        
        let tile = self.tiles[position]
        tile?.remove(feature: feature)
    }
}

/// MARK: river related methods

extension Grid {
    
    public func flows(at position: GridPoint) -> [FlowDirection] {
        
        // check bounds
        guard self.has(gridPoint: position) else {
            return []
        }
        
        let tile = self.tiles[position]
        if let flows = tile?.flows {
            return flows
        }
        
        return []
    }

    public func add(river: River) {
        
        self.rivers.append(river)
        
        for riverPoint in river.points {
            
            // check bounds
            guard self.has(gridPoint: riverPoint.point) else {
                continue
            }
            
            let tile = self.tiles[riverPoint.point]
            tile?.set(river: river)
            do {
                try tile?.setRiver(flow: riverPoint.flowDirection)
            } catch {
                print("something weird happend")
            }
        }
    }
}
