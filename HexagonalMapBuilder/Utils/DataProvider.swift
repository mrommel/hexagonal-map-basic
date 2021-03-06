//
//  DataProvider.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 05.05.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation
import Cocoa
import HexagonalMapKit

private let kMapChangedNotification = "kMapChangedNotification"
private let kMapsLoadedNotification = "kMapsLoadedNotification"


class DataProvider: MapDataProvider {

    static let fileExtension = ".map"
    static var mapsLoading = false
    static var mapsLoaded = false
    static let mapsLock = DispatchSemaphore(value: 1)
    static let timeout: DispatchTime = DispatchTime.distantFuture
    static var maps = [String: Map]()

    var delegate: MapDataProviderDelegate?

    lazy var documentPath: String? = {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        if let path = paths.first {
            return path + "/"
        } else {
            return nil
        }
    }()

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(DataProvider.mapChangedNotificationReceived(notificiation:)), name: NSNotification.Name(rawValue: kMapChangedNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(DataProvider.mapsLoadedNotificationReceived(notificiation:)), name: NSNotification.Name(rawValue: kMapsLoadedNotification), object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}


/// Public Data Access Methods
extension DataProvider {

    func maps(completionHandler: @escaping MapsCompletionBlock) {

        _ = DataProvider.mapsLock.wait(timeout: DataProvider.timeout)
        let maps = Array(DataProvider.maps.values)
        DataProvider.mapsLock.signal()
        completionHandler(maps)
    }


    func map(id: String, completionHandler: @escaping MapCompletionBlock) {

        _ = DataProvider.mapsLock.wait(timeout: DataProvider.timeout)
        let map = DataProvider.maps[id]
        DataProvider.mapsLock.signal()
        completionHandler(map)
    }
    
    func delete(id: String, completionHandler: @escaping VoidCompletionBlock) {
        
        if self.deleteFile(id + DataProvider.fileExtension) {
            completionHandler()
        }
    }

    func save(map: Map, completionHandler: @escaping ErrorCompletionBlock) {

        saveMapToFile(map: map) { (error) in

            if error == nil {
                _ = DataProvider.mapsLock.wait(timeout: DataProvider.timeout)
                DataProvider.maps[map.id] = map
                DataProvider.mapsLock.signal()
            }
            
            // Allow the completion handler to fire before letting all the other DataProviders know the data has changed
            completionHandler(error)
            
            if error == nil {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kMapChangedNotification), object: self, userInfo: ["id": map.id])
            }

        }
    }
}


/// Notification Handlers
extension DataProvider {

    @objc func mapChangedNotificationReceived(notificiation: NSNotification) {

        if let userInfo = notificiation.userInfo, let id = userInfo["id"] as? String {
            delegate?.mapChanged(id: id)
        }
    }


    @objc func mapsLoadedNotificationReceived(notificiation: NSNotification) {

        delegate?.mapsLoaded()
    }
}


/// Methods for handling reading notes from file and saving them to file
extension DataProvider {

    func loadMaps() {

        guard !DataProvider.mapsLoaded && !DataProvider.mapsLoading else {
        
            if DataProvider.mapsLoaded {
                delegate?.mapsAlreadyLoaded()
            }
            
            return
        }

        DataProvider.mapsLoading = true

        // Ensure we have exclusive access to the Notes Dictionary
        loadMapFiles { (maps) in

            var mapsDictionary = [String: Map]()
            for map in maps {
                mapsDictionary[map.id] = map
            }

            _ = DataProvider.mapsLock.wait(timeout: DataProvider.timeout)
            DataProvider.maps = mapsDictionary
            DataProvider.mapsLock.signal()
            DataProvider.mapsLoading = false
            DataProvider.mapsLoaded = true
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kMapsLoadedNotification), object: self)
        }
    }

    //TODO: This function should thow be marked as throws and raise any errors
    private func loadMapFiles(completionHandler: @escaping MapsCompletionBlock) {

        DispatchQueue.global(qos: .background).async {

            var maps = [Map]()
            if let path = self.documentPath {
                let fs: FileManager = FileManager.default
                do {
                    let contents: Array = try fs.contentsOfDirectory(atPath: path)
                    for fileName in contents {
                        if fileName.hasSuffix(DataProvider.fileExtension) {
                            do {
                                if let map = try self.loadMapFromFile(fileName) {
                                    maps.append(map)
                                }
                            } catch let error as NSError {
                                NSLog("Error loading map file: \(fileName) => \(error)")
                            }
                        }
                    }
                } catch let error as NSError {

                    //TODO: This code needs to generate an error
                    NSLog("Error \(error)")
                }

                completionHandler(maps)
            }
        }
    }

    func deleteFile(_ fileName: String) -> Bool {
    
        guard let documentPath = self.documentPath else {
            return false
        }
        
        let filePath = documentPath + fileName
        
        let fs: FileManager = FileManager.default
        do {
            try fs.removeItem(atPath: filePath)
        } catch let error as NSError {
            NSLog("Error deleting map file: \(fileName) => \(error)")
            return false
        }
        
        return true
    }

    func loadMapFromFile(_ fileName: String) throws -> Map? {

        guard let documentPath = documentPath else { return nil }

        var result: Map?
        let filePath = documentPath + fileName

        let jsonData = try NSData(contentsOf: NSURL(fileURLWithPath: filePath) as URL, options: NSData.ReadingOptions.mappedIfSafe)
        let object = try JSONSerialization.jsonObject(with: jsonData as Data, options: .allowFragments)
        if let dictionary = object as? [String: AnyObject] {
            result = makeMapFromJSON(object: dictionary)
        }
        return result
    }


    func saveMapToFile(map: Map, completionHandler: @escaping ErrorCompletionBlock) {

        // TODO: Create Error
        guard let documentPath = documentPath else {
            completionHandler(nil)
            return
        }

        DispatchQueue.global(qos: .background).async {

            // Turn the dictionary into JSON data then a JSON String.
            do {
                let jsonString = try map.toJSONString()
                let filePath = documentPath + map.id + DataProvider.fileExtension
                try jsonString.write(toFile: filePath, atomically: true, encoding: String.Encoding.utf8)
                completionHandler(nil)
            } catch let error as NSError {
                completionHandler(error)
            }
        }
    }


    private func makeMapFromJSON(object: [String: AnyObject]) -> Map? {

        do {
            let map = try Map(object: object)

            // set continents from list to tiles
            if let continents = map.continents {
                for continent in continents {
                    if let points = continent.points {
                        for point in points {
                            map.grid?.tiles[point]?.continent = continent
                        }
                    }
                }
            }
            
            // set rivers
            
            return map
            
        } catch let error as NSError {
            //completionHandler(error)
            print("error during parsing map: \(error)")
            return nil
        }
        
        
    }
}
