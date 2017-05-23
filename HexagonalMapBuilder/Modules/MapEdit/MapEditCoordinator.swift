//
//  MapEditCoordinator.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 05.05.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation
import Cocoa

class MapEditCoordinator {

    var editWindowController: NSWindowController?

    func edit(id: String) {

        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        editWindowController = storyboard.instantiateController(withIdentifier: "MapEditWindowController") as? NSWindowController
        guard let editWindowController = editWindowController else {
            fatalError("The Edit Window Controller Cannot be found");
        }
        guard let editViewController = editWindowController.window?.contentViewController as? MapEditViewController else {
            fatalError("The Edit View Controller Cannot be found");
        }

        let mapEditController = EditController(id: id)
        mapEditController.dataProvider = DataProvider()
        mapEditController.coordinatorDelegate = self

        editViewController.controller = mapEditController
        editWindowController.showWindow(self)
    }


    func focus() {
        editWindowController?.window?.makeKeyAndOrderFront(self)
    }
}



extension MapEditCoordinator: MapEditControllerCoordinatorDelegate {

    func mapEditControllerDone(controller: MapEditController) {
        editWindowController?.close()
        editWindowController = nil
        //done()
    }
}
