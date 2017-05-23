//
//  MapListPresenter.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 23.05.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation

protocol MapListPresenterInput: class {
    
    func setupUI()
}

protocol MapListPresenterOutput: class {
    
    func setupUI(_ data: MapListViewModel)
    func refreshUI()
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
}
