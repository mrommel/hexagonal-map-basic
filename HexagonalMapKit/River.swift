//
//  River.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 04.04.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

// swiftlint:disable cyclomatic_complexity

import Foundation
import EVReflection

// taken from here: https://en.wikipedia.org/wiki/List_of_rivers_by_length
let riverNames = ["Amazon", "Nile", "Yangtze", "Mississippi", "Yenisei", "Huang He", "Ob", "Río de la Plata", "Congo", "Amur", "Lena", "Mekong", "Mackenzie", "Niger", "Murray", "Tocantins", "Volga", "Euphrates", "Madeira", "Purús", "Yukon", "Indus", "São Francisco", "Syr Darya", "Salween", "Saint Lawrence", "Rio Grande", "Lower Tunguska", "Brahmaputra", "Donau"]

public class RiverPoint: EVObject {
    
    public let point: GridPoint
    public let flowDirection: FlowDirection
    
    public init(with point: GridPoint, and flowDirection: FlowDirection) {
        
        self.point = point
        self.flowDirection = flowDirection
    }
    
    required convenience public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required public init() {
        fatalError("init() has not been implemented")
    }
}

public class River: EVObject {
    
    public var name: String = ""
    public var points: [RiverPoint] = []
    
    public init(with name: String, and points: [GridPointWithCorner]) {
        
        super.init()
        
        self.name = name
        self.points = []
        self.translate(points: points)
    }
    
    required public init() {
        //fatalError("init() has not been implemented")
    }
    
    /**
        translate the list of points into river flows
     */
    public func translate(points: [GridPointWithCorner]) {
        
        var prev = points.first
        for point in points.suffix(from: 1) {
            
            self.points.append(self.riverPoint(from: prev!, to: point))
            
            prev = point
        }
        
    }
    
    public func riverPoint(from: GridPointWithCorner, to: GridPointWithCorner) -> RiverPoint {
        
        if from.point == to.point {
            if from.corner == .northEast && to.corner == .east {
                return RiverPoint(with: from.point, and: .southEast)
            } else if from.corner == .east && to.corner == .northEast {
                return RiverPoint(with: from.point, and: .northWest)
            }
            
            if from.corner == .east && to.corner == .southEast {
                return RiverPoint(with: from.point, and: .southWest)
            } else if from.corner == .southEast && to.corner == .east {
                return RiverPoint(with: from.point, and: .northEast)
            }
            
            if from.corner == .northEast && to.corner == .northWest {
                return RiverPoint(with: from.point, and: .west)
            } else if from.corner == .northWest && to.corner == .northEast {
                return RiverPoint(with: from.point, and: .east)
            }
            
            // we need to move to the northWest neighboring tile
            let northWestNeighbor = from.point.neighbor(in: .northWest)
            if from.corner == .northWest && to.corner == .west {
                return RiverPoint(with: northWestNeighbor, and: .southWest)
            } else if from.corner == .west && to.corner == .northWest {
                return RiverPoint(with: northWestNeighbor, and: .northEast)
            }
            
            // we need to move to the south neighboring tile
            let southNeighbor = from.point.neighbor(in: .south)
            if from.corner == .southWest && to.corner == .southEast {
                return RiverPoint(with: southNeighbor, and: .east)
            } else if from.corner == .southEast && to.corner == .southWest {
                return RiverPoint(with: southNeighbor, and: .west)
            }
            
            // we need to move to the southWest neighboring tile
            let southWestNeighbor = from.point.neighbor(in: .southWest)
            if from.corner == .west && to.corner == .southWest {
                return RiverPoint(with: southWestNeighbor, and: .southEast)
            } else if from.corner == .southWest && to.corner == .west {
                return RiverPoint(with: southWestNeighbor, and: .northWest)
            }
        } else {
            let dir = from.point.direction(towards: to.point)
            
            switch dir {
            case .northEast:
                // GridPointWithCorner(11,6 / east), to: GridPointWithCorner(12,6 / southEast)
                // GridPointWithCorner(17,10 / east), to: GridPointWithCorner(18,10 / southEast)
                if from.corner == .east && to.corner == .southEast {
                    let southEastNeighbor = from.point.neighbor(in: .southEast)
                    return RiverPoint(with: southEastNeighbor, and: .east)
                }
                break
            case .southEast:
                // GridPointWithCorner(1,12 / southEast), to: GridPointWithCorner(2,13 / southWest)
                if from.corner == .southEast && to.corner == .southWest {
                    let southNeighbor = from.point.neighbor(in: .south)
                    return RiverPoint(with: southNeighbor, and: .southEast)
                }
                break
            case .south:
                // GridPointWithCorner(11,0 / southWest), to: GridPointWithCorner(11,1 / west)
                if from.corner == .southWest && to.corner == .west {
                    let southWestNeighbor = from.point.neighbor(in: .southWest)
                    return RiverPoint(with: southWestNeighbor, and: .southWest)
                }
                break
            case .southWest:
                // GridPointWithCorner(19,1 / west), to: GridPointWithCorner(18,2 / northWest)
                if from.corner == .west && to.corner == .northWest {
                    return RiverPoint(with: to.point, and: .west)
                }
                break
            case .northWest:
                // GridPointWithCorner(6,6 / northWest), to: GridPointWithCorner(5,5 / northEast)
                if from.corner == .northWest && to.corner == .northEast {
                    return RiverPoint(with: to.point, and: .northWest)
                }
                break
            case .north:
                // GridPointWithCorner(5,13 / northEast), to: GridPointWithCorner(5,12 / east)
                if from.corner == .northEast && to.corner == .east {
                    return RiverPoint(with: to.point, and: .northEast)
                }
                break
            }
        }
        
        assert(false, "Condition from: \(from), to: \(to) not handled")
    }
}

