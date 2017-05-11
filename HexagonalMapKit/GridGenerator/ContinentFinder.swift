//
//  ContinentFinder.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 06.03.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation
import Buckets

class ContinentFinder {
    
    static let kNotAnalyzedContinent: Int = 254
    static let kNoContinent: Int = 255
    
    let continentIdentifiers: Array2D<Int>
    
    init(width: Int, height: Int) {
        
        self.continentIdentifiers = Array2D<Int>(columns: width, rows: height)
        
        for x in 0..<width {
            for y in 0..<height {
                self.continentIdentifiers[x, y] = ContinentFinder.kNotAnalyzedContinent
            }
        }
    }
    
    func evaluated(value: Int) -> Bool {
        
        return value != ContinentFinder.kNotAnalyzedContinent && value != ContinentFinder.kNoContinent
    }
    
    func execute(on map: Map) -> [Continent] {
        
        for x in 0..<self.continentIdentifiers.columnCount() {
            for y in 0..<self.continentIdentifiers.rowCount() {
                
                self.evaluate(x: x, y: y, on: map)
            }
        }
        
        var continents = [Continent]()
        
        for x in 0..<self.continentIdentifiers.columnCount() {
            for y in 0..<self.continentIdentifiers.rowCount() {
                
                if let continentIdentifier = self.continentIdentifiers[x, y] {
                
                    if self.evaluated(value: continentIdentifier) {
                        
                        var continent = continents.first(where: { $0.identifier == continentIdentifier })
                        
                        if continent == nil {
                            continent = Continent(withIdentifier: continentIdentifier, andName: "Continent \(continentIdentifier)", andPoints: [], on: map)
                            continents.append(continent!)
                        }
                        
                        map.set(continent: continent, at: GridPoint(x: x, y: y))
                        
                        continent?.points?.append(GridPoint(x: x, y: y))
                    }
                }
            }
        }
        
        return continents
    }
    
    func evaluate(x: Int, y: Int, on map: Map) {
        
        let p0 = GridPoint(x: x, y: y)
        
        if (map.grid?.isGround(at: p0))! {
            let p1 = p0.neighbor(in: .north)
            let p2 = p0.neighbor(in: .northWest)
            let p3 = p0.neighbor(in: .southWest)
            
            let c1 = (map.grid?.has(gridPoint: p1))! ? (self.continentIdentifiers[p1.x, p1.y])! : ContinentFinder.kNotAnalyzedContinent
            let c2 = (map.grid?.has(gridPoint: p2))! ? (self.continentIdentifiers[p2.x, p2.y])! : ContinentFinder.kNotAnalyzedContinent
            let c3 = (map.grid?.has(gridPoint: p3))! ? (self.continentIdentifiers[p3.x, p3.y])! : ContinentFinder.kNotAnalyzedContinent
            
            if self.evaluated(value: c1) {
                self.continentIdentifiers[x, y] = c1
            } else if self.evaluated(value: c2) {
                self.continentIdentifiers[x, y] = c2
            } else if self.evaluated(value: c3) {
                self.continentIdentifiers[x, y] = c3
            } else {
                let freeIdentifier = self.firstFreeIdentifier()
                self.continentIdentifiers[x, y] = freeIdentifier
            }
            
            // handle continent joins
            if self.evaluated(value: c1) && self.evaluated(value: c2) && c1 != c2 {
                self.replace(oldIdentifier: c2, withIdentifier: c1)
            } else if self.evaluated(value: c2) && self.evaluated(value: c3) && c2 != c3 {
                self.replace(oldIdentifier: c2, withIdentifier: c3)
            } else if self.evaluated(value: c1) && self.evaluated(value: c3) && c1 != c3 {
                self.replace(oldIdentifier: c1, withIdentifier: c3)
            }
            
        } else {
            self.continentIdentifiers[x, y] = ContinentFinder.kNoContinent
        }
    }
    
    func firstFreeIdentifier() -> Int {
        
        var freeIdentifiers = BitArray(repeating: true, count: 256)
        
        for x in 0..<self.continentIdentifiers.columnCount() {
            for y in 0..<self.continentIdentifiers.rowCount() {
                
                let c = (self.continentIdentifiers[x, y])!
                if c >= 0 && c < 256 {
                    freeIdentifiers[c] = false
                }
            }
        }
        
        for i in 0..<256 {
            if freeIdentifiers[i] {
                return i
            }
        }
        
        return ContinentFinder.kNoContinent
    }
    
    func replace(oldIdentifier: Int, withIdentifier newIdentifier: Int) {
        
        for x in 0..<self.continentIdentifiers.columnCount() {
            for y in 0..<self.continentIdentifiers.rowCount() {
                
                if (self.continentIdentifiers[x, y])! == oldIdentifier {
                    self.continentIdentifiers[x, y] = newIdentifier
                }
            }
        }
    }
}
