//
//  EditController.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 05.05.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation
import HexagonalMapKit

protocol MapEditControllerCoordinatorDelegate: class {
    
    func mapEditControllerDone(controller: MapEditController)
}

class EditController: MapEditController {
    
    weak var viewDelegate: MapEditControllerViewDelegate?
    weak var coordinatorDelegate: MapEditControllerCoordinatorDelegate?
    
    var map: Map? {
        didSet {
            viewDelegate?.mapDidChange(editController: self)
        }
    }
    
    var id: String {
        didSet {
            loadMap()
        }
    }
    
    var dataProvider: MapDataProvider? {
        didSet {
            loadMap()
        }
    }
    
    public init(id: String) {
        
        self.id = id
    }
    
    func loadMap() {
        dataProvider?.map(id: id) { (map) in
            DispatchQueue.main.async {
                self.map = map
            }
        }
    }
    
    func generateMap(withOptions options: GridGeneratorOptions) {
        self.map = Map(withOptions: options)
        self.map?.id = self.id
        self.map?.title = "Generated"
    }
}



/// NoteEditController Protocol Methods
extension EditController {
    
    func cancel() {
        coordinatorDelegate?.mapEditControllerDone(controller: self)
    }
}
