//
//  EditController.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 05.05.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation
/*import HexagonalMapKit

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
        
        let tmp = Map(withOptions: options, completionHandler: { progress in
            print("generateMap => \(progress)")
        })
        
        tmp.id = self.id
        tmp.title = "Generated \(options.mapSize.width)x\(options.mapSize.height)"
        tmp.teaser = "Climate: \(options.climateZoneOption), Water: \(options.waterPercentage*100)%"
        
        self.map = tmp
        
    }

    func saveMap() {
        dataProvider?.save(map: self.map!, completionHandler: { (error) in
            if let error = error {
                print("saved with error: \(error)")
            } else {
                print("saved with success")
            }
        })
    }
}



/// NoteEditController Protocol Methods
extension EditController {
    
    func cancel() {
        coordinatorDelegate?.mapEditControllerDone(controller: self)
    }
}*/
