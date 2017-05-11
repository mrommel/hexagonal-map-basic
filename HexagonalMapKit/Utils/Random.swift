//
//  Random.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 04.04.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation

extension Int {
    
    // Returns a random Int point number between 0 and Int.max.
    public static var random: Int {
        get {
            return Int.random(num: Int.max)
        }
    }
    
    /**
     Random integer between 0 and n-1.
     
     - parameter num: Int
     
     - returns: Int
     */
    public static func random(num: Int) -> Int {
        return Int(arc4random_uniform(UInt32(num)))
    }
    
    /**
     Random integer between min and max
     
     - parameter min: Int
     - parameter max: Int
     
     - returns: Int
     */
    public static func random(min: Int = 0, max: Int) -> Int {
        return Int.random(num: max - min + 1) + min
    }
}

extension Integer {
    
    public func sign() -> Int {
        return (self < 0 ? -1 : 1)
    }
    /* or, use signature: func sign() -> Self */
}

extension Double {
    
    // Returns a random floating point number between 0.0 and 1.0, inclusive.
    public static var random: Double {
        get {
            return Double(arc4random()) / 0xFFFFFFFF
        }
    }
    
    /**
     Create a random number Double
     
     - parameter min: Double
     - parameter max: Double
     
     - returns: Double
     */
    public static func random(min: Double, max: Double) -> Double {
        return Double.random * (max - min) + min
    }
    
    public static func rad2Deg(angleInRad: Double) -> Double {
        
        return angleInRad * 180.0 / pi
    }
}

extension Float {
    
    // Returns a random floating point number between 0.0 and 1.0, inclusive.
    public static var random: Float {
        get {
            return Float(arc4random()) / 0xFFFFFFFF
        }
    }
    
    /**
     Create a random num Float
     
     - parameter min: Float
     - parameter max: Float
     
     - returns: Float
     */
    public static func random(min: Float, max: Float) -> Float {
        return Float.random * (max - min) + min
    }
    
    public static func reduceAngle(angle: Float) -> Float {
        
        var value = angle
        while value >= 360 { value -= 360 }
        while value < 0 { value +=  360 }
        
        return value
    }
    
    public static func rad2Deg(angleInRad: Float) -> Float {
        
        return angleInRad * 180.0 / pi
    }
}
