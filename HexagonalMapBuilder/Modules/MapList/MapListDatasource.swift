//
//  MapListDatasource.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 23.05.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation
import HexagonalMapKit

protocol MapListDatasourceInput: class {

    func reloadData()
    func numberOfItemsInList() -> Int
    func mapAt(row: Int) -> Map?
    
    func deleteMapWith(identifier: String)

    func loadMaps()
}

class MapListDatasource {

    var interactor: MapListInteractorInput?
    var dataProvider: MapDataProvider?

    required init() {
        self.dataProvider = DataProvider()
        self.dataProvider?.delegate = self
    }

    var maps: [Map] = [Map]() {
        didSet {
            self.interactor?.onMapsLoaded()
        }
    }
}


extension MapListDatasource: MapListDatasourceInput {

    func mapAt(row: Int) -> Map? {

        guard row >= 0 && row < maps.count else {
            return nil
        }

        return self.maps[row]
    }

    func numberOfItemsInList() -> Int {
        return maps.count
    }
    
    func deleteMapWith(identifier: String) {
        
        if let dataProvider = self.dataProvider {
            DispatchQueue.main.async() {
                dataProvider.delete(id: identifier, completionHandler: {
                    print("deleted")
                    self.maps = self.maps.filter() { $0.id != identifier }
                    self.mapDeleted(identifier: identifier)
                })
            }
        }
    }

    func reloadData() {
        return
    }

    func loadMaps() {

        if let dataProvider = self.dataProvider {
            DispatchQueue.main.async() {
                dataProvider.loadMaps()
            }
        }
    }

}

extension MapListDatasource: MapDataProviderDelegate {

    func mapDeleted(identifier: String) {
        print("deleted \(identifier)")
        DispatchQueue.main.async() {
            self.interactor?.onMapDeleted()
        }
    }

    func mapChanged(id: String) {
        print("changed")
    }

    func mapsLoaded() {

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
