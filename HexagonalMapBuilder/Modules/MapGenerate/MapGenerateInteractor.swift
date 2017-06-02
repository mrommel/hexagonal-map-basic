//
//  MapGenerateInteractor.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 02.06.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation

protocol MapGenerateInteractorInput: class {
    
    func startMapGeneration()
}


class MapGenerateInteractor {
    
    var coordinator: AppCoordinatorInput?
}

extension MapGenerateInteractor: MapGenerateInteractorInput {
    
    func startMapGeneration() {

        // TODO
        
        self.coordinator?.closeGeneratorWindow()
    }
    
}
