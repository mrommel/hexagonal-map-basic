//
//  MapListDatasource.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 23.05.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation
import HexagonalMapKit

typealias ContentChangeBlock = ((Void) -> Void)?

protocol MapListDatasourceProtocol: class {
    
    func reloadData ()
    func numberOfItemsInList() -> Int
    func mapAt (row: Int) -> Map?
    
    func loadMaps()
}

class MapListDatasource {
    
    var interactor: MapListInteractorOutput?
    var dataProvider: MapDataProvider?
    
    required init() {
        self.dataProvider = DataProvider()
    }
    
    var maps: [Map] = [Map]() {
        didSet {
            self.interactor?.onMapsLoaded()
        }
    }
    
    
}

extension MapListDatasource: MapListDatasourceProtocol {
    
    func mapAt(row: Int) -> Map? {
        
        guard row >= 0 && row < maps.count else {
            return nil
        }
        
        return self.maps[row]
    }

    func numberOfItemsInList() -> Int {
        return maps.count
    }

    func reloadData() {
        return
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
