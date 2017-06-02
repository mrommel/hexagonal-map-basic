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
    
    func save(map: Map?)
    
    func showGenerateDialog()
    
    func closeWindow()
}

protocol MapEditInteractorOutput: class {
    
    func onLoaded(map: Map?)
    func onFailedLoadingMap()
    
    func onSaved()
    func onFailedSavingMapWith(error: Error)
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
    
    func save(map: Map?) {
        
        if let datasource = self.datasource {
            datasource.save(map: map)
        } else {
            self.onFailedSavingMapWith(error: MapError.noDatasource)
        }
    }
    
    func showGenerateDialog() {
        
        self.coordinator?.showMapGenerateDialog()
    }
    
    func closeWindow() {
        
        self.coordinator?.closeMapEditWindow()
    }
}

extension MapEditInteractor: MapEditInteractorOutput {
    
    func onFailedLoadingMap() {
        
    }

    func onLoaded(map: Map?) {
        self.presenter?.updateWith(map: map)
    }
    
    func onSaved() {
        DispatchQueue.main.async {
            self.presenter?.showAlertWith(title: "Success", message: "Map got saved")
        }
    }
    
    func onFailedSavingMapWith(error: Error) {
        DispatchQueue.main.async {
            self.presenter?.showError(error: error)
        }
    }
}
