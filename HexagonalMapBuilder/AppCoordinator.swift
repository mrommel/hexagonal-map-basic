//
//  AppCoordinator.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 05.05.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation
import Cocoa

protocol AppCoordinatorInput: class {
    
    func showMapList()
    func showMapEditForNew()
    func showMapEditFor(identifier: String)
}


/**
 The AppCoordinator controls the main flow of the application
 */
class AppCoordinator {

    fileprivate var mapListWindowController: NSWindowController!
    fileprivate var mapEditWindowController: NSWindowController!
    fileprivate var window: NSWindow!
    
    func start() {
        showMapList()
    }
}

extension AppCoordinator: AppCoordinatorInput {

    func showMapList() {

        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        self.mapListWindowController = storyboard.instantiateController(withIdentifier: "MapListWindowController") as? NSWindowController
        self.window = mapListWindowController.window

        guard let mapListViewController = self.window.contentViewController as? MapListViewController else {
            fatalError("The Map List View Controller Cannot be found");
        }

        let mapListPresenter = MapListPresenter()
        let mapListInteractor = MapListInteractor()
        let mapListDatasource = MapListDatasource()
        
        mapListPresenter.userInterface = mapListViewController
        mapListPresenter.interactor = mapListInteractor
        
        mapListInteractor.presenter = mapListPresenter
        mapListInteractor.datasource = mapListDatasource
        mapListInteractor.coordinator = self
        
        mapListDatasource.interactor = mapListInteractor

        mapListViewController.presenter = mapListPresenter
        mapListViewController.interactor = mapListInteractor
        
        self.mapListWindowController.showWindow(self)
    }
    
    func showMapEditForNew() {
        print("showMapEditForNew")
    }
    
    func showMapEditFor(identifier: String) {
    
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        self.mapEditWindowController = storyboard.instantiateController(withIdentifier: "MapEditWindowController") as? NSWindowController
        guard (self.mapEditWindowController) != nil else {
            fatalError("The Edit Window Controller Cannot be found");
        }
        guard let editViewController = self.mapEditWindowController.window?.contentViewController as? MapEditViewController else {
            fatalError("The Edit View Controller Cannot be found");
        }
        
        let mapEditPresenter = MapEditPresenter()
        let mapEditInteractor = MapEditInteractor()
        let mapEditDatasource = MapEditDatasource()
        
        mapEditPresenter.userInterface = editViewController
        mapEditPresenter.interactor = mapEditInteractor
        
        mapEditInteractor.presenter = mapEditPresenter
        mapEditInteractor.coordinator = self
        mapEditInteractor.mapIdentifier = identifier
        mapEditInteractor.datasource = mapEditDatasource
        
        mapEditDatasource.interactor = mapEditInteractor
        
        editViewController.presenter = mapEditPresenter
        editViewController.interactor = mapEditInteractor
        
        self.mapEditWindowController.showWindow(self)
    }
}


/*extension AppCoordinator {

    func newMap() {
        print("AppCoordinator.newMap()")
        editMap(id: NSUUID().uuidString)
    }

    func editMap(id: String) {
        print("AppCoordinator.editMap(\(id))")

        let coordinator = MapEditCoordinator()
        coordinator.delegate = self
        coordinator.edit(id: id)
        coordinator.key = id
        coordinator.focus()
    }

    func previewMap(id: String, position: NSPoint, timeBasedDisplay: Bool = false) {
        print("AppCoordinator.previewMap(\(id))")
        /*let previewCoordinator = PreviewCoordinator()
        previewCoordinator.delegate = self
        previewCoordinator.start(id: id, position: position, timeBasedDisplay: timeBasedDisplay)
        coordinators[previewCoordinator.key] = previewCoordinator*/
    }
}*/
