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
    
    var moderate: ClimateZone {
        switch self {
        case .polar:
            return .subpolar
        case .subpolar:
            return .temperate
        case .temperate:
            return .subtropic
        case .subtropic:
            return .subtropic
        case .tropic:
            return .tropic
        }
    }
}

enum ClimateZoneOption {
    
    case earth
    
    case polarOnly
    case subpolarOnly
    case temperateOnly
    case subtropicOnly
    case tropicOnly
}

class GridGeneratorOptions {

    let climateZoneOption: ClimateZoneOption
    let waterPercentage: Float
    
    required init(climateZoneOption: ClimateZoneOption, waterPercentage: Float) {
        
        self.climateZoneOption = climateZoneOption
        self.waterPercentage = waterPercentage
    }
}

typealias CompletionHandler = (Float) -> (Void)

class GridGenerator {
    
    let width: Int
    let height: Int
    
    let terrain: Array2D<Terrain>
    let zones: Array2D<ClimateZone>
    let distanceToCoast: Array2D<Int>
    
    var completionHandler: CompletionHandler?
    
    /**
        creates a new grid generator for a map of `width`x`height` dimension
 
        - Parameter width: width of the resulting map
        - Parameter height: height of the resulting map
     */
    required public init(width: Int, height: Int) {
        
        self.width = width
        self.height = height
        
        // prepare terrain, distanceToCoast and zones
        self.terrain = Array2D<Terrain>(columns: self.width, rows: self.height)
        self.distanceToCoast = Array2D<Int>(columns: self.width, rows: self.height)
        self.zones = Array2D<ClimateZone>(columns: self.width, rows: self.height)
    }
    
    func generateGrid(with options: GridGeneratorOptions) -> Grid? {
        
        // prepare result value
        let grid = Grid(width: self.width, height: self.height)
        
        // 0st step: height and moisture map
        let heightMap = HeightMap(width: width, height: height)
        let moistureMap = HeightMap(width: width, height: height)
        
        if let completionHandler = self.completionHandler {
            completionHandler(0.2)
        }
        
        // 1st step: land / water
        self.fillFromElevation(withWaterPercentage: options.waterPercentage, on: heightMap)
        
        if let completionHandler = self.completionHandler {
            completionHandler(0.4)
        }
        
        // 2nd step: climate
        switch options.climateZoneOption  {
        case .earth:
            self.setClimateZones()
            break
        case .polarOnly:
            self.setClimateZones(with: .polar)
            break
        case .subpolarOnly:
            self.setClimateZones(with: .subpolar)
            break
        case .temperateOnly:
            self.setClimateZones(with: .temperate)
            break
        case .subtropicOnly:
            self.setClimateZones(with: .subtropic)
            break
        case .tropicOnly:
            self.setClimateZones(with: .tropic)
            break
        }
        
        if let completionHandler = self.completionHandler {
            completionHandler(0.45)
        }
        
        // 2.1nd step: refine climate based on cost distance
        self.prepareDistanceToCoast()
        self.refineClimate()
        
        if let completionHandler = self.completionHandler {
            completionHandler(0.5)
        }
        
        // 3rd step: refine terrain
        self.refineTerrain(on: grid, with: heightMap, and: moistureMap)
        
        if let completionHandler = self.completionHandler {
            completionHandler(0.8)
        }
        
        // 4th step: rivers
        // self.placeRivers(options.rivers)
        
        if let completionHandler = self.completionHandler {
            completionHandler(1.0)
        }
        
        return grid
    }
    
    // MARK: 1st step methods
    
    func waterOrLandFrom(elevation: Float, waterLevel: Float) -> Terrain {
    
        if elevation < waterLevel {
            return Terrain.water
        }
    
        return Terrain.ground
    }
    
    func fillFromElevation(withWaterPercentage waterPercentage: Float, on heightMap: HeightMap) {
        
        let waterLevel = heightMap.findWaterLevel(forWaterPercentage: waterPercentage)
        
        for x in 0..<width {
            for y in 0..<height {
                guard let height = heightMap[x, y] else {
                    continue
                }
                
                let terrainType = self.waterOrLandFrom(elevation: height, waterLevel: waterLevel)
                
                if terrainType == Terrain.water {
                    self.terrain[x, y] = Terrain.ocean
                } else {
                    self.terrain[x, y] = Terrain.grass
                }
            }
        }
    }
    
    // MARK: 2nd step methods
    
    func setClimateZones() {
        
        self.zones.fill(with: .temperate)
        
        for x in 0..<width {
            for y in 0..<height {
                
                let latitude = fabs(Float(height / 2 - y)) / Float(height / 2)

                if latitude > 0.8 {
                    self.zones[x, y] = .polar
                } else if latitude > 0.6 {
                    self.zones[x, y] = .subpolar
                } else if latitude > 0.4 {
                    self.zones[x, y] = .temperate
                } else if latitude > 0.2 {
                    self.zones[x, y] = .subtropic
                } else {
                    self.zones[x, y] = .tropic
                }
            }
        }
        
        return
    }
    
    func setClimateZones(with zone: ClimateZone) {
        
        self.zones.fill(with: zone)
    }
    
    /**
     this function assumes that the self.terrain is filled with Terrain.ocean or Terrain.grass only
     */
    func refineClimate() {
        
        for x in 0..<width {
            for y in 0..<height {
              
                guard let distance = self.distanceToCoast[x, y] else {
                    continue
                }
                
                if distance < 2 {
                    self.zones[x, y] = self.zones[x, y]?.moderate
                }
            }
        }
    }
    
    func prepareDistanceToCoast() {
    
        self.distanceToCoast.fill(with: Int.max)
        
        var actionHappened: Bool = true
        while actionHappened {
            
            // reset 
            actionHappened = false
            
            for x in 0..<width {
                for y in 0..<height {
                
                    // this needs to be analyzed
                    if self.distanceToCoast[x, y] == Int.max {
                    
                        // if field is ocean => no distance
                        if self.terrain[x, y] == Terrain.ocean {
                            self.distanceToCoast[x, y] = 0
                            actionHappened = true
                        } else {
                            // check neighbors
                            var distance = Int.max
                            let pt = GridPoint(x: x, y: y)
                            for dir in GridPointDirection.all {
                                
                                let neighbor = pt.neighbor(in: dir)
                                if neighbor.x >= 0 && neighbor.x < self.width && neighbor.y >= 0 && neighbor.y < self.height {
                                    
                                    if self.distanceToCoast[x, y] != Int.max {
                                        distance = min(distance, self.distanceToCoast[x, y]! + 1)
                                    }
                                }
                            }
                            
                            if distance < Int.max {
                                self.distanceToCoast[x, y] = distance
                                actionHappened = true
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: 3rd step methods
    
    func refineTerrain(on grid: Grid?, with heightMap: HeightMap, and moistureMap: HeightMap) {
        
        for x in 0..<width {
            for y in 0..<height {
                let gridPoint = GridPoint(x: x, y: y)
                
                if self.terrain[x, y] == Terrain.ocean {
                    
                    grid?.set(terrain: .ocean, at: gridPoint)
                    
                    // TODO: also add shore
                } else {
                    
                    let terrainVal = self.biome(elevation: heightMap[x, y]!, moisture: moistureMap[x, y]!, climate: self.zones[x, y]!)
                    
                    grid?.set(terrain: terrainVal, at: gridPoint)
                    
                    if moistureMap[x, y]! > 0.5 {
                        switch terrainVal {
                        case .grass:
                            // TODO forest
                            
                            if self.zones[x, y]! == .subtropic {
                                // TODO rain forest
                            }
                            
                            break
                        case .desert:
                            // TODO oasis
                            break
                        case .plains:
                            // TODO forest
                            
                            if self.zones[x, y]! == .subtropic {
                                // TODO rain forest
                            }
                            
                            break
                        case .tundra:
                            // TODO taiga
                            break
                        default:
                            break
                        }
                    }
                    
                    if heightMap[x, y]! > 0.7 {
                        // TODO hill
                    } else if heightMap[x, y]! > 0.85 {
                        // TODO mountain
                    }
                }
            }
        }
    }

    
    // from http://www.redblobgames.com/maps/terrain-from-noise/
    func biome(elevation: Float, moisture: Float, climate: ClimateZone) -> Terrain {
        
        switch climate {
        case .polar:
            return .snow
        case .subpolar:
            if elevation > 0.6 {
                return .snow
            }
            
            return .tundra
        case .temperate:
            if elevation > 0.9 {
                return .snow
            }
            
            if moisture < 0.5 {
                return .plains
            } else {
                return .grass
            }
        case .subtropic:
            if elevation > 0.9 {
                return .snow
            }
            
            if moisture < 0.2 {
                return .desert
            } else if moisture < 0.6 {
                return .plains
            } else {
                return .grass
            }
        case .tropic:
            if elevation > 0.9 {
                return .snow
            }
            
            if moisture < 0.5 {
                return .desert
            } else {
                return .plains
            }
        }
    }
}
