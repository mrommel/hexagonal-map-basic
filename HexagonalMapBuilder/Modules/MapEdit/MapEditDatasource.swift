//
//  MapEditDatasourceInput.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 29.05.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation
import HexagonalMapKit

enum MapError: Error {
    
    case noDatasource
}

protocol MapEditDatasourceInput {
    
    func loadMapWith(identifier: String)
    
    func save(map: Map?)
}

class MapEditDatasource {
    
    var interactor: MapEditInteractorOutput?
    var dataProvider: MapDataProvider?
    var identifier: String?
    
    required init() {
        self.dataProvider = DataProvider()
        self.dataProvider?.delegate = self
    }
    
    var maps: [Map] = [Map]() {
        
        didSet {
            let map = maps.first(where: {$0.id == self.identifier})
            
            if let map = map {
                self.interactor?.onLoaded(map: map)
            } else {
                self.interactor?.onFailedLoadingMap()
            }
        }
    }
}

extension MapEditDatasource: MapEditDatasourceInput {
    
    func loadMapWith(identifier: String) {
        
        self.identifier = identifier
        
        if let dataProvider = self.dataProvider {
            DispatchQueue.main.async() {
                dataProvider.loadMaps()
            }
        }
    }
    
    func save(map: Map?) {
        
        if let dataProvider = self.dataProvider {
            dataProvider.save(map: map!, completionHandler: { (error) in
                if let error = error {
                    print("saved with error: \(error)")
                    self.interactor?.onFailedSavingMapWith(error: error)
                } else {
                    print("saved with success")
                    self.interactor?.onSaved()
                }
            })
        }
    }
}

extension MapEditDatasource: MapDataProviderDelegate {
    
    func mapDeleted(identifier id: String) {
        print("--> MapEditDatasource mapDeleted(id: \(id))")
    }
    
    func mapChanged(id: String) {
        print("--> MapEditDatasource mapChanged(id: \(id))")
    }
    
    func mapsAlreadyLoaded() {
        self.mapsLoaded()
    }
    
    func mapsLoaded() {
        
        if let dataProvider = dataProvider {
            dataProvider.maps(completionHandler: { (maps) in
                DispatchQueue.main.async() {
                    self.maps = maps
                }
            })
        } else {
            self.maps = [Map]()
        }
    }
}
