//
//  ArrayExtension.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 04.04.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation

// http://stackoverflow.com/questions/27259332/get-random-elements-from-array-in-swift
extension Array {
    
    /// Returns an array containing this sequence shuffled
    public var shuffled: Array {
        var elements = self
        return elements.shuffle()
    }
    
    /// Shuffles this sequence in place
    @discardableResult
    public mutating func shuffle() -> Array {
        indices.dropLast().forEach {
            guard case let index = Int(arc4random_uniform(UInt32(count - $0))) + $0, index != $0 else { return }
            swap(&self[$0], &self[index])
        }
        return self
    }
    
    public var chooseOne: Element { return self[Int(arc4random_uniform(UInt32(count)))] }
    
    public func choose(_ num: Int) -> Array { return Array(shuffled.prefix(num)) }
}

extension Array {
    
    public func randomItem() -> Element {
        let index = Int.random(min: 0, max: self.count - 1)
        return self[index]
    }
}
