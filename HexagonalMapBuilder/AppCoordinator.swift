//
//  AppCoordinator.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 05.05.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation
import Cocoa
import HexagonalMapKit

protocol AppCoordinatorInput: class {
    
    func showMapList()
    
    func showMapEditForNew()
    func showMapEditFor(identifier: String)
    func closeMapEditWindow()
    
    func showMapGenerateDialog()
    func closeGeneratorWindow()
}


/**
 The AppCoordinator controls the main flow of the application
 */
class AppCoordinator {

    fileprivate var mapListWindowController: NSWindowController!
    fileprivate var mapEditWindowController: NSWindowController!
    fileprivate var mapGenerateWindowController: NSWindowController!
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
        
        let options = GridGeneratorOptions(withSize: .duel, zone: .earth, waterPercentage: 0.3, rivers: 4)
        let map = Map(withOptions: options, completionHandler: { progress in
            
            if progress == 1.0 {
                print("Map created")
            }
        })
        
        let dataProvider = DataProvider()
        dataProvider.save(map: map, completionHandler: { error in
            if let error = error {
                print("Map saved with error: \(error)")
            } else {
                print("Map saved without errors")
            }
        })
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
    
    func closeMapEditWindow() {
        
        self.mapEditWindowController.close()
    }
    
    func showMapGenerateDialog() {
        
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        self.mapGenerateWindowController = storyboard.instantiateController(withIdentifier: "MapGenerateWindowController") as? NSWindowController
        guard (self.mapGenerateWindowController) != nil else {
            fatalError("The Generate Window Controller Cannot be found");
        }
        guard let generateViewController = self.mapGenerateWindowController.window?.contentViewController as? MapGenerateViewController else {
            fatalError("The Edit View Controller Cannot be found");
        }
        
        let mapGeneratePresenter = MapGeneratePresenter()
        let mapGenerateInteractor = MapGenerateInteractor()

        mapGeneratePresenter.userInterface = generateViewController
        mapGeneratePresenter.interactor = mapGenerateInteractor
        
        //mapGenerateInteractor.
        mapGenerateInteractor.coordinator = self
        
        
        generateViewController.interactor = mapGenerateInteractor
        generateViewController.presenter = mapGeneratePresenter
        
        self.mapGenerateWindowController.showWindow(self)
    }
    
    func closeGeneratorWindow() {
        
        self.mapGenerateWindowController.close()
    }
}
