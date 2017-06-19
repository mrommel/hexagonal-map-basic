//
//  AppDelegate.swift
//  HexagonalMapBuilder
//
//  Created by Michael Rommel on 19.04.17.
//  Copyright © 2017 MiRo Soft. All rights reserved.
//

// https://github.com/macdevnet/macOS-Notes-Demo

import Cocoa
import HexagonalMapKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    private var appCoordinator: AppCoordinator!
    
    @IBOutlet weak var newMapMenuItem: NSMenuItem!
    @IBOutlet weak var saveMapMenuItem: NSMenuItem!
    @IBOutlet weak var generateRandomMapMenuItem: NSMenuItem!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        appCoordinator = AppCoordinator()
        appCoordinator.start()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    /// MARK: file menu
    
    func enable(newMapMenu enabled: Bool) {
        self.newMapMenuItem.isEnabled = enabled
    }
    
    func enable(saveMenu enabled: Bool) {
        self.saveMapMenuItem.isEnabled = enabled
    }

    /// MARK: generate menu
    
    func enable(generateRandomMenu enabled: Bool) {
        self.generateRandomMapMenuItem.isEnabled = enabled
    }

}
