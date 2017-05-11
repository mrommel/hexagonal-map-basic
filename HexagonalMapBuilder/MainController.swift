//
//  MainController.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 05.05.17.
//  Copyright © 2017 MiRo. All rights reserved.
//


import Cocoa
import HexagonalMapKit

protocol MapMainControllerCoordinatorDelegate: class
{
    func newMap()
    func editMap(id: String)
    func previewMap(id: String, position: NSPoint, timeBasedDisplay: Bool)
}

class MainController {
    
    weak var viewDelegate: MapMainControllerViewDelegate?
    weak var coordinatorDelegate: MapMainControllerCoordinatorDelegate?
    
    var dataProvider: MapDataProvider? {
        
        willSet {
            dataProvider?.delegate = nil
        }
        didSet {
            dataProvider?.delegate = self
            loadMaps()
        }
    }
    
    var maps: [Map] = [Map]() {
        didSet {
            viewDelegate?.mapsDidChange(controller: self)
        }
    }
    
    var numberOfMaps: Int {
        return maps.count
    }
    
}


/// MapMainController Methods
extension MainController: MapMainController {
    
    func map(index: Int) -> Map? {
        
        guard index >= 0 && index < maps.count else {return nil}
        return maps[index]
    }
    
    
    func editMap(index: Int) {
        
        if let map = map(index: index) {
            coordinatorDelegate?.editMap(id: map.id)
        }
    }
    
    
    func previewMap(index: Int, position: NSPoint) {
        
        if let map = map(index: index) {
            coordinatorDelegate?.previewMap(id: map.id, position: position, timeBasedDisplay: false)
        }
    }
    
    func newMap() {
        
        coordinatorDelegate?.newMap()
    }
}



/// NoteDataProviderDelegate Methods
extension MainController: MapDataProviderDelegate {
    
    func mapChanged(id: String) {
        
        DispatchQueue.main.async() {
            self.loadMaps()
        }
    }
    
    func mapsLoaded() {
        
        DispatchQueue.main.async() {
            self.loadMaps()
        }
    }
    
    func loadMaps() {
        
        if let dataProvider = dataProvider {
            dataProvider.maps(completionHandler: { (maps) in
                DispatchQueue.main.async() {
                    self.maps = maps
                }
            })
        } else {
            self.maps = [Map]()
        }
    }
}
