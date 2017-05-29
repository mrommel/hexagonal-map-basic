//
//  MapEditPresenter.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 28.05.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation
import HexagonalMapKit

protocol MapEditPresenterInput: class {
    
    func setupUI()
    func updateWith(map: Map?)
}

protocol MapEditPresenterOutput: class {
    
    func setupUI(_ data: MapEditViewModel)
    func refreshUI(_ data: MapEditViewModel)
}

class MapEditPresenter {

    weak var userInterface: MapEditPresenterOutput?
    var interactor: MapEditInteractorInput?
}

extension MapEditPresenter: MapEditPresenterInput {
    
    func setupUI() {
        
        let model = MapEditViewModel(title: "Loading", map: nil)
        self.userInterface?.setupUI(model)
        
        self.interactor?.loadMap()
    }
    
    func updateWith(map: Map?) {
        
        let model = MapEditViewModel(title: "Loaded", map: map)
        self.userInterface?.refreshUI(model)
    }
    
}
