//
//  File.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 06.03.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation

class HeightMap: Array2D<Float> {
    
    required init(width: Int, height: Int) {
        
        super.init(columns: width, rows: height)
        
        self.generate(withOctaves: 4, zoom: 80, andPersistence: 0.52)
    }
    
    required init(width: Int, height: Int, octaves: Int, zoom: Float, andPersistence persistence: Float) {
        
        super.init(columns: width, rows: height)
        
        self.generate(withOctaves: octaves, zoom: zoom, andPersistence: persistence)
    }
    
    /**
     generates the heightmap based on the input parameters
     
     - parameter octaves: 4
     - parameter zoom: 80
     - parameter persistence: 0.52
     */
    func generate(withOctaves octaves: Int, zoom: Float, andPersistence persistence: Float) {
        
        let generator = PerlinGenerator()
        
        generator.octaves = octaves
        generator.zoom = zoom
        generator.persistence = persistence
        
        for x in 0..<self.columnCount() {
            for y in 0..<self.rowCount() {
                
                let e0 = 1.00 * generator.perlinNoise(x: 1.0 * Float(x), y: 1.0 * Float(y), z: 0, t: 0)
                let e1 = 0.50 * generator.perlinNoise(x: 2.0 * Float(x), y: 2.0 * Float(y), z: 0, t: 0)
                let e2 = 0.25 * generator.perlinNoise(x: 4.0 * Float(x), y: 4.0 * Float(y), z: 0, t: 0)
                
                var val = abs(e0 + e1 + e2)
                if val > 1 {
                    val = 1
                }
                
                self[x, y] = powf(val, 1.97)
            }
        }
    }
    
    func percentage(below threshold: Float) -> Float {
        
        var belowNum: Float = 0
        var aboveNum: Float = 0
        
        for x in 0..<self.columnCount() {
            for y in 0..<self.rowCount() {
                let value = self[x, y]
                if value! < threshold {
                    belowNum += 1.0
                } else {
                    aboveNum += 1.0
                }
            }
        }
        
        return Float(belowNum / (belowNum + aboveNum))
    }
    
    func findWaterLevel(forWaterPercentage waterPercentage: Float) -> Float {
        
        var waterLevel: Float = 0.05
        var calculatedWaterPercentage: Float = self.percentage(below: waterLevel)
        
        while calculatedWaterPercentage < waterPercentage {
            waterLevel += 0.05
            calculatedWaterPercentage = self.percentage(below: waterLevel)
        }
        
        return waterLevel
    }
}
