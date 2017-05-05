//
//  AppDelegate.swift
//  HexagonalMapBuilder
//
//  Created by Michael Rommel on 19.04.17.
//  Copyright © 2017 MiRo Soft. All rights reserved.
//

// https://github.com/macdevnet/macOS-Notes-Demo

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    private var appCoordinator: AppCoordinator!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        appCoordinator = AppCoordinator()
        appCoordinator.start()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @IBAction func newDocument(sender: NSMenuItem) {
        print("new")
    }
 
}
