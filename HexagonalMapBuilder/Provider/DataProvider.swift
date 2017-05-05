//
//  DataProvider.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 05.05.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation
import Cocoa
import HexagonalMap

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
        loadMaps()
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
        
        guard !DataProvider.mapsLoaded && !DataProvider.mapsLoading else { return }
        
        DataProvider.mapsLoading = true
        
        // Ensure we have exclusive access to the Notes Dictionary
        loadMapFiles { (maps) in
            
            var mapsDictionary = [String:Map]()
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
    
    
    func loadMapFromFile(_ fileName: String) throws -> Map? {
        
        guard let documentPath = documentPath else { return nil}
        
        var result: Map?
        let filePath = documentPath + fileName
        
        let jsonData = try NSData(contentsOf: NSURL(fileURLWithPath: filePath) as URL, options: NSData.ReadingOptions.mappedIfSafe)
        let object = try JSONSerialization.jsonObject(with: jsonData as Data, options: .allowFragments)
        if let dictionary = object as? [String: AnyObject] {
            result =  makeMapFromJSON(object: dictionary)
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
            
            //convert the RTF to base64 - just makes less issues when storing the content as JSON
            //let base64String = data.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
            
            // Create a dictionary from the note that can then be converted to JSON
            var dictionary = [String: String]()
            dictionary["id"] = map.id
            dictionary["title"] = map.title
            dictionary["teaser"] = map.teaser
            dictionary["text"] = map.text
            
            // Turn the dictionary into JSON data then a JSON String.
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: JSONSerialization.WritingOptions())
                let jsonString = String(data: jsonData, encoding: String.Encoding.utf8)
                let filePath = documentPath + map.id + DataProvider.fileExtension
                try jsonString?.write(toFile: filePath, atomically: true, encoding: String.Encoding.utf8)
                completionHandler(nil)
            } catch let error as NSError {
                completionHandler(error)
            }
        }
    }
    
    
    private func makeMapFromJSON(object: [String: AnyObject]) -> Map? {
        
        guard let id = object["id"] as? String,
            let title = object["title"] as? String,
            let teaser = object["teaser"] as? String,
            let text = object["text"] as? String
            else {
                return nil
        }
        
        let map = Map(width: 12, height: 12)
        
        map.id = id
        map.title = title
        map.teaser = teaser
        map.text = text
        
        return map
    }
}
