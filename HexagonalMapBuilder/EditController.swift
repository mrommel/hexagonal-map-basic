//
//  EditController.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 05.05.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation
import HexagonalMap

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

    /*var noteValues: (title: String, content: NSAttributedString) {
        
        if let map = map {
            return (note.title, note.content)
        } else {
            return ("", NSAttributedString(string: ""))
        }
    }*/
    
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
}



/// NoteEditController Protocol Methods
extension EditController {
    
    func cancel() {
        coordinatorDelegate?.mapEditControllerDone(controller: self)
    }
}
