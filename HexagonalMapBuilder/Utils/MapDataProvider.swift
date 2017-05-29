//
//  MapDataProvider.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 05.05.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation
import HexagonalMapKit

protocol MapDataProviderDelegate: class {

    func mapChanged(id: String)
    func mapsLoaded()
    func mapsAlreadyLoaded()
}

extension MapDataProviderDelegate {

    //? Dummy implementation to make the method sort of optional
    func mapsLoaded() {
    }
    
    func mapsAlreadyLoaded() {
        
    }
}


typealias MapCompletionBlock = (_ map: Map?) -> Void
typealias MapsCompletionBlock = (_ maps: [Map]) -> Void
typealias ErrorCompletionBlock = (_ error: Error?) -> Void

protocol MapDataProvider {

    var delegate: MapDataProviderDelegate? { get set }
    func maps(completionHandler: @escaping MapsCompletionBlock)
    func map(id: String, completionHandler: @escaping MapCompletionBlock)
    func save(map: Map, completionHandler: @escaping ErrorCompletionBlock)

    func loadMaps()
}
