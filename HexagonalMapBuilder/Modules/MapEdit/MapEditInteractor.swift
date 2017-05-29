//
//  MapEditInteractor.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 28.05.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation
import HexagonalMapKit

protocol MapEditInteractorInput: class {
    
    func loadMap()
    
    func onLoaded(map: Map?)
    func onFailedLoadingMap()
}

protocol MapEditInteractorOutput: class {
    
}

class MapEditInteractor {
    
    var presenter: MapEditPresenterInput?
    var coordinator: AppCoordinatorInput?
    var datasource: MapEditDatasourceInput?
    var mapIdentifier: String?

}

extension MapEditInteractor: MapEditInteractorInput {
    
    func loadMap() {
        if let datasource = self.datasource, let mapIdentifier = self.mapIdentifier {
            datasource.loadMapWith(identifier: mapIdentifier)
        } else {
            self.onFailedLoadingMap()
        }
    }
}

extension MapEditInteractor: MapEditInteractorOutput {
    
    func onFailedLoadingMap() {
        
    }

    func onLoaded(map: Map?) {
        self.presenter?.updateWith(map: map)
    }

    
}
