//
//  Tile.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 14.02.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation
import Buckets
import EVReflection

public enum FlowDirection: String {
    
    case none = ""
    case any = "*"
    
    // flow of river on north edge
    case west = "w"
    case east = "e"
    
    // flow of river on ne edge
    case northWest = "nw"
    case southEast = "se"
    
    // flow of river on se edge
    case northEast = "ne"
    case southWest = "sw"
}

enum FlowDirectionError: Error, Equatable {
    case Unsupported(flow: FlowDirection, in: GridPointDirection)
}

func == (lhs: FlowDirectionError, rhs: FlowDirectionError) -> Bool {
    switch (lhs, rhs) {
    case (.Unsupported(let leftFlow, let leftDir), .Unsupported(let rightFlow, let rightDir)):
        return leftFlow == rightFlow && leftDir == rightDir
    }
}

public class Tile: EVObject {
    
    public var point: GridPoint
    public var terrain: Terrain? = Terrain.ocean
    public var features: [Feature] = []
    public var discovered: BitArray = [false, false, false, false, false, false, false, false]
    public var road: Bool = false
    public var continent: Continent?
    
    // river properties
    public var river: River?
    public var riverFlowNorth: FlowDirection = .none
    public var riverFlowNorthEast: FlowDirection = .none
    public var riverFlowSouthEast: FlowDirection = .none
    
    required public init(at point: GridPoint, withTerrain terrain: Terrain) {
        
        self.point = point
        self.terrain = terrain
    }
    
    required public init() {
        
        self.point = GridPoint()
    }
    
    public var possibleImprovements: [TileImprovementType] {
        
        if let terrain = self.terrain {
            switch terrain {
            case .shore:
                return [.fishing]
            case .grass:
                if self.has(feature: .forest) {
                    return [.lumbermill]
                } else if self.has(feature: .hill) {
                    return [.pasture]
                } else {
                    return [.farm, .pasture]
                }
            default:
                return []
            }
        }
        
        return []
    }
    
    override public func skipPropertyValue(_ value: Any, key: String) -> Bool {
        
        if key == "continent" {
            return true
        }
        
        if key == "river" {
            return true
        }
        
        return false
    }
    
    override public func setValue(_ value: Any!, forUndefinedKey key: String) {
        
        /*if key == "point" {
            if let dict = value as? NSDictionary {
                self.point = GridPoint(x: 1, y: 1)
            }
            return
        }*/
        
        if key == "terrain" {
            if let rawValue = value as? String {
                if let terrainValue = Terrain.enumFrom(string: rawValue) {
                    self.terrain = terrainValue
                    print("have set terrain: \(terrainValue)")
                }
            }
            return
        }
        
        if key == "features" {
            if let enumList = value as? NSArray {
                self.features = []
                for item in enumList {
                    if let rawValue = item as? String, let featureType = Feature.enumFrom(string: rawValue) {
                        self.features.append(featureType)
                    }
                }
            }
            return
        }
        
        if key == "riverFlowNorthEast" {
            if let rawValue = value as? String {
                if let flowValue = FlowDirection(rawValue: rawValue) {
                    self.riverFlowNorthEast = flowValue
                }
            }
            return
        }
        
        if key == "riverFlowSouthEast" {
            if let rawValue = value as? String {
                if let flowValue = FlowDirection(rawValue: rawValue) {
                    self.riverFlowSouthEast = flowValue
                }
            }
            return
        }
        
        if key == "riverFlowNorth" {
            if let rawValue = value as? String {
                if let flowValue = FlowDirection(rawValue: rawValue) {
                    self.riverFlowNorth = flowValue
                }
            }
            return
        }
        
        if key == "discovered" {
            return
        }

        print("---> Tile.setValue for key '\(key)' should be handled.")
    }
}

/// MARK: feature handling

extension Tile {
    
    public func set(feature: Feature) {

        if !self.has(feature: feature) {
            self.features.append(feature)
        }
    }
    
    public func remove(feature: Feature) {
        
        if self.has(feature: feature) {
            let featureIndex = self.features.index(of: feature)
            self.features.remove(at: featureIndex!)
        }
    }
    
    public func has(feature: Feature) -> Bool {
        
        for tileFeature in self.features {
            if tileFeature == feature {
                return true
            }
        }
        
        return false
    }
}

// MARK: river handling

/**
  north: east <> west
    o####o
   /      # northEast: northWest <> southEast
  /        #
 o          o
  \        #
   \      # southEst: northEast <> southWest
    o----o
 */
extension Tile {
    
    public func set(river: River) {
        
        self.river = river
    }
    
    public func isRiver() -> Bool {
        
        return self.river != nil && (self.isRiverInNorth() || self.isRiverInNorthEast() || self.isRiverInSouthEast())
    }
    
    public func isRiverIn(direction: GridPointDirection) throws -> Bool {
        switch direction {
        case .north:
            return self.isRiverInNorth()
        case .northEast:
            return self.isRiverInNorthEast()
        case .southWest:
            return self.isRiverInSouthEast()

        default:
            throw FlowDirectionError.Unsupported(flow: .none, in: direction)
        }
    }
    
    public func setRiver(flow: FlowDirection) throws {
        
        switch flow {
        case .northEast:
            try self.setRiverFlowInSouthEast(flow: flow)
            break
        case .southWest:
            try self.setRiverFlowInSouthEast(flow: flow)
            break
    
        case .northWest:
            try self.setRiverFlowInNorthEast(flow: flow)
            break
        case .southEast:
            try self.setRiverFlowInNorthEast(flow: flow)
            break
            
        case .east:
            try self.setRiverFlowInNorth(flow: flow)
            break
        case .west:
            try self.setRiverFlowInNorth(flow: flow)
            break
        default:
            throw FlowDirectionError.Unsupported(flow: flow, in: .north)
        }
    }
    
    public func setRiver(flow: FlowDirection, in direction: GridPointDirection) throws {
        
        switch direction {
        case .north:
            try self.setRiverFlowInNorth(flow: flow)
            break
        case .northEast:
            try self.setRiverFlowInNorthEast(flow: flow)
            break
        case .southEast:
            try self.setRiverFlowInSouthEast(flow: flow)
            break
        default:
            throw FlowDirectionError.Unsupported(flow: flow, in: direction)
        }
    }
    
    // river in north can flow from east or west direction
    public func isRiverInNorth() -> Bool {
        return self.riverFlowNorth == .east || self.riverFlowNorth == .west
    }
    
    public func setRiverFlowInNorth(flow: FlowDirection) throws {
        
        guard flow == .east || flow == .west else {
            throw FlowDirectionError.Unsupported(flow: flow, in: .north)
        }
        
        self.riverFlowNorth = flow
    }
    
    // river in north east can flow to northwest or southeast direction
    public func isRiverInNorthEast() -> Bool {
        return self.riverFlowNorthEast == .northWest || self.riverFlowNorthEast == .southEast
    }
    
    public func setRiverFlowInNorthEast(flow: FlowDirection) throws {
        
        guard flow == .northWest || flow == .southEast else {
            throw FlowDirectionError.Unsupported(flow: flow, in: .northEast)
        }
        
        self.riverFlowNorthEast = flow
    }
    
    // river in south east can flow to northeast or southwest direction
    public func isRiverInSouthEast() -> Bool {
        return self.riverFlowSouthEast == .southWest || self.riverFlowSouthEast == .northEast
    }
    
    public func setRiverFlowInSouthEast(flow: FlowDirection) throws {
        
        guard flow == .southWest || flow == .northEast else {
            throw FlowDirectionError.Unsupported(flow: flow, in: .southEast)
        }
        
        self.riverFlowSouthEast = flow
    }
    
    public var flows: [FlowDirection] {
        var result: [FlowDirection] = []
        
        if self.isRiverInNorth() {
            result.append(self.riverFlowNorth)
        }
        
        if self.isRiverInNorthEast() {
            result.append(self.riverFlowNorthEast)
        }
        
        if self.isRiverInSouthEast() {
            result.append(self.riverFlowSouthEast)
        }
        
        return result
    }
}

// MARK: discovery handling

extension Tile {

    public func discovered(by player: PlayerType) -> Bool {
        return self.discovered[player.rawValue]
    }
    
    public func discover(by player: PlayerType) {
        self.discovered[player.rawValue] = true
    }
}
