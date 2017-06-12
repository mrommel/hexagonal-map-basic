//
//  MapGeneratePresenter.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 02.06.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation
import HexagonalMapKit

protocol MapGeneratePresenterInput: class {
    
    func setupUI()
}

protocol MapGeneratePresenterOutput: class {
    
    func setupUI(_ data: MapGenerateViewModel)
    func refreshUI(_ data: MapGenerateViewModel)
}

class MapGeneratePresenter {
 
    weak var userInterface: MapGeneratePresenterOutput?
    var interactor: MapGenerateInteractorInput?
}

extension MapGeneratePresenter: MapGeneratePresenterInput {
    
    func setupUI() {
        
        let options = GridGeneratorOptions(withSize: .small, zone: .earth, waterPercentage: 0.5, rivers: 3)
        
        let model = MapGenerateViewModel(title: "Loading", options: options)
        self.userInterface?.setupUI(model)
    }
    
    /*func updateWith(map: Map?) {
        
        let model = MapEditViewModel(title: "Loaded", map: map)
        self.userInterface?.refreshUI(model)
    }*/

}
