//
//  GridGenerator.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 13.02.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation
import SpriteKit

class GridGenerator {
    
    let width: Int
    let height: Int
    
    let terrain: Array2D<Terrain>
    private var generator = PerlinGenerator()
    
    required public init?(width: Int, height: Int) {
        
        self.width = width
        self.height = height
        
        self.terrain = Array2D<Terrain>(columns: self.width, rows: self.height)
    }
    
    func elevation() -> Array2D<Float> {

        let heightMap = Array2D<Float>(columns: self.width, rows: self.height)
        
        generator.octaves = 4
        generator.zoom = 80
        generator.persistence = 0.52
        
        for x in 0..<width {
            for y in 0..<height {
                
                let e0 = 1.00 * generator.perlinNoise(x: 1.0 * Float(x), y: 1.0 * Float(y), z: 0, t: 0)
                let e1 = 0.50 * generator.perlinNoise(x: 2.0 * Float(x), y: 2.0 * Float(y), z: 0, t: 0)
                let e2 = 0.25 * generator.perlinNoise(x: 4.0 * Float(x), y: 4.0 * Float(y), z: 0, t: 0)
                
                var val = abs(e0 + e1 + e2)
                if val > 1 {
                    val = 1
                }
                
                heightMap[x, y] = powf(val, 1.97)
            }
        }
        
        return heightMap
    }
    
    // from http://www.redblobgames.com/maps/terrain-from-noise/
    func biome(e: Float, level: Float) -> Terrain {
        
        if e < level {
            return Terrain.water
        }
        
        return Terrain.ground
        
        /*if e < 0.1 return OCEAN
        if e < 0.12 return BEACH
        
        if e > 0.8 {
            if m < 0.1 return SCORCHED
            if m < 0.2 return BARE
            if m < 0.5 return TUNDRA
            return SNOW
        }
        
        if (e > 0.6) {
            if (m < 0.33) return TEMPERATE_DESERT
            if (m < 0.66) return SHRUBLAND
            return TAIGA
        }
        
        if (e > 0.3) {
            if (m < 0.16) return TEMPERATE_DESERT
            if (m < 0.50) return GRASSLAND
            if (m < 0.83) return TEMPERATE_DECIDUOUS_FOREST
            return TEMPERATE_RAIN_FOREST
        }
        
        if (m < 0.16) return SUBTROPICAL_DESERT
        if (m < 0.33) return GRASSLAND
        if (m < 0.66) return TROPICAL_SEASONAL_FOREST
        return TROPICAL_RAIN_FOREST*/
    }
    
    func fill(with terrain: Terrain) {
        for x in 0..<width {
            for y in 0..<height {
                self.terrain[x, y] = terrain
            }
        }
    }
    
    func fillFromElevation(withWaterPercentage waterPercentage: Float) {
        
        let elevationMap = self.elevation()
        
        let waterLevel = self.findWaterLevel(in: elevationMap, forWaterPercentage: waterPercentage)
        
        for x in 0..<width {
            for y in 0..<height {
                let terrainType = self.biome(e: elevationMap[x, y]!, level: waterLevel)
                
                if terrainType == Terrain.water {
                    self.terrain[x, y] = Terrain.ocean
                } else {
                    self.terrain[x, y] = Terrain.grass
                }
            }
        }
    }
    
    func waterPercentage(in elevationMap: Array2D<Float>, at waterLevel: Float) -> Float {
        
        var waterNum: Float = 0
        var groundNum: Float = 0
        
        for x in 0..<width {
            for y in 0..<height {
                let terrainType = self.biome(e: elevationMap[x, y]!, level: waterLevel)
                
                if terrainType == Terrain.water {
                    waterNum += 1.0
                } else {
                    groundNum += 1.0
                }
            }
        }
        
        return Float(waterNum / (waterNum + groundNum))
    }
    
    func findWaterLevel(in elevationMap: Array2D<Float>, forWaterPercentage: Float) -> Float {
        
        var waterLevel: Float = 0.05
        var waterPercentage: Float = self.waterPercentage(in: elevationMap, at: waterLevel)
        
        while waterPercentage < forWaterPercentage {
            waterLevel += 0.05
            waterPercentage = self.waterPercentage(in: elevationMap, at: waterLevel)
        }
        
        return waterLevel
    }
    
    func generate() -> Grid? {
        
        let grid = Grid(width: self.width, height: self.height)
        
        for x in 0..<width {
            for y in 0..<height {
                let gridPoint = GridPoint(x: x, y: y)
                let terrainVal = self.terrain[x, y]
                grid?.set(terrain: terrainVal!, at: gridPoint)
            }
        }
        
        return grid
    }
}

class HeightMap {
    
}
