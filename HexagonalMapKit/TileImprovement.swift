//
//  TileImprovement.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 22.02.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation
import JSONCodable

public enum TileImprovementType {
    
    case none
    
    case road
    
    case farm
    case pasture
    case plantation
    case lumbermill
    
    case mine
    case quarry
    
    case fishing
    
    public var image: String {
        switch self {
            
        case .none:
            return "---"
            
        case .road:
            return "Road"
            
        case .farm:
            return "Farm"
        case .pasture:
            return "Pasture"
        case .plantation:
            return "Plantation"
        case .lumbermill:
            return "Lumbermill"
            
        case .mine:
            return "Mine"
        case .quarry:
            return "Quarry"
            
        case .fishing:
            return "Fishing"
        }
    }
}

public class TileImprovement: MapItem {
    
    public let type: TileImprovementType
    
    public required init(at point: GridPoint, of type: TileImprovementType) {
        
        self.type = type
        
        super.init(at: point)
    }
    
    public required init(at point: GridPoint) {
        
        self.type = .none
        
        super.init(at: point)
    }
    
    convenience public init() {
        
        self.init(at: GridPoint(x: 0, y: 0))
    }
    
    public required init(object: JSONObject) throws {
        fatalError("init(object:) has not been implemented")
    }
}
