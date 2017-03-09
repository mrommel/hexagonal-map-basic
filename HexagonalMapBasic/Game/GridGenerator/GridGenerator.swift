//
//  GridGenerator.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 13.02.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation
import SpriteKit

enum ClimateZone: Int {
    
    case polar
    case subpolar
    case temperate
    case subtropic
    case tropic
}

class GridGenerator {
    
    let width: Int
    let height: Int
    
    let terrain: Array2D<Terrain>
    
    required public init(width: Int, height: Int) {
        
        self.width = width
        self.height = height
        
        self.terrain = Array2D<Terrain>(columns: self.width, rows: self.height)
    }
    
    // from http://www.redblobgames.com/maps/terrain-from-noise/
    func biome(elevation: Float, level: Float) -> Terrain {
        
        if elevation < level {
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
        
        let heightMap = HeightMap(width: width, height: height)

        let waterLevel = heightMap.findWaterLevel(forWaterPercentage: waterPercentage)
        
        for x in 0..<width {
            for y in 0..<height {
                let terrainType = self.biome(elevation: (heightMap[x, y]!), level: waterLevel)
                
                if terrainType == Terrain.water {
                    self.terrain[x, y] = Terrain.ocean
                } else {
                    self.terrain[x, y] = Terrain.grass
                }
            }
        }
    }
    
    func identifyClimateZones() -> Array2D<ClimateZone> {
        
        let zones = Array2D<ClimateZone>(columns: self.width, rows: self.height)
        zones.fill(with: .temperate)
        
        // TODO: calculate climate zone based on height + distance to coast
        for x in 0..<width {
            for y in 0..<height {
                
                let latitude = fabs(Float(height / 2 - y)) / Float(height / 2)
                
                if latitude > 0.8 {
                    zones[x, y] = .polar
                } else if latitude > 0.6 {
                    zones[x, y] = .subpolar
                } else if latitude > 0.4 {
                    zones[x, y] = .temperate
                } else if latitude > 0.2 {
                    zones[x, y] = .subtropic
                } else {
                    zones[x, y] = .tropic
                }
            }
        }
        
        return zones
    }
    
    func createClimateZones(with zone: ClimateZone) -> Array2D<ClimateZone> {
        
        let zones = Array2D<ClimateZone>(columns: self.width, rows: self.height)
        zones.fill(with: zone)
        return zones
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

