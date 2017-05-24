//
//  MapListPresenter.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 23.05.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation
import HexagonalMapKit

protocol MapListPresenterInput: class {
    
    func setupUI()
    func updateWith(maps: [Map])
}

protocol MapListPresenterOutput: class {
    
    func setupUI(_ data: MapListViewModel)
    func refreshUI(_ data: MapListViewModel)
}

class MapListPresenter {
    
    weak var userInterface: MapListPresenterOutput?
    var interactor: MapListInteractorInput?
    
}

extension MapListPresenter: MapListPresenterInput {
    
    func setupUI() {
        let model = MapListViewModel(title: "Loading", loaded: false, maps: nil)
        self.userInterface?.setupUI(model)
        
        self.interactor?.loadMaps()
    }
    
    func updateWith(maps: [Map]) {
        print("--> MapListPresenter.updateWith")
        let model = MapListViewModel(title: "Loaded", loaded: true, maps: maps)
        self.userInterface?.refreshUI(model)
    }
}
