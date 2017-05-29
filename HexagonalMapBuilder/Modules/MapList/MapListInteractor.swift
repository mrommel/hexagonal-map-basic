//
//  MainController.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 05.05.17.
//  Copyright © 2017 MiRo. All rights reserved.
//


import Cocoa
import HexagonalMapKit

protocol MapListInteractorInput: class {
    
    func loadMaps()

    func newMap()
    func editMap(index: Int)
    
    func onMapsLoaded()
}

protocol MapListInteractorOutput: class {
    
}

/**
 
 */
class MapListInteractor {
    
    var presenter: MapListPresenterInput?
    var datasource: MapListDatasourceInput?
    var coordinator: AppCoordinatorInput?
    
    func map(index: Int) -> Map? {
        return self.datasource?.mapAt(row: index)
    }
}


/// Methods
extension MapListInteractor: MapListInteractorInput {
    
    func loadMaps() {
        if let datasource = self.datasource {
            datasource.loadMaps()
        }
    }
    
    func editMap(index: Int) {
        
        if let map = map(index: index) {
            self.coordinator?.showMapEditFor(identifier: map.id)
        }
    }
    
    func newMap() {

        self.coordinator?.showMapEditForNew()
    }

    func onMapsLoaded() {
        
        var maps: [Map] = []
        
        let maxMaps: Int = (self.datasource?.numberOfItemsInList())!
        for index in 0..<maxMaps {
            if let map = self.datasource?.mapAt(row: index) {
                maps.append(map)
            }
        }
        
        self.presenter?.updateWith(maps: maps)
    }
}
