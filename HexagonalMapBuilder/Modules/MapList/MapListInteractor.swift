//
//  MainController.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 05.05.17.
//  Copyright © 2017 MiRo. All rights reserved.
//


import Cocoa
import HexagonalMapKit

protocol MapListInteractorOutput: class {
    
    
}

protocol MapListInteractorInput: class {
    
    func loadMaps()

    func newMap()
    func editMap(index: Int)
    
    func onMapsLoaded()
}

/**
 
 */
class MapListInteractor {
    
    var presenter: MapListPresenterInput?
    var datasource: MapListDatasourceProtocol?
    var coordinator: AppCoordinatorInput?
    
    func map(index: Int) -> Map? {
        return self.datasource?.mapAt(row: index)
    }
}


/// MapMainController Methods
extension MapListInteractor: MapListInteractorInput {
    
    func loadMaps() {
        if let datasource = self.datasource {
            datasource.loadMaps()
        }
    }
    
    func onMapsLoaded() {
        print("loaded maps")
        //self.presenter.mapsDidChange()
    }
    
    func editMap(index: Int) {
        
        if let map = map(index: index) {
            self.coordinator?.showMapEditFor(identifier: map.id)
        }
    }
    
    func newMap() {

        self.coordinator?.showMapEditForNew()
    }
}
