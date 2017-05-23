//
//  AppCoordinator.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 05.05.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation
import Cocoa

protocol Coordinator {

    var key: String { get }
}

protocol CoordinatorDelegate: class {

    func done(coordinator: Coordinator)
}


class BaseCoordinator: Coordinator {

    var key = NSUUID().uuidString
    weak var delegate: CoordinatorDelegate?

    func done() {
        delegate?.done(coordinator: self)
    }
}

/// The AppCoordinator controls the main flow of the application
class AppCoordinator {

    private var mainWindowController: NSWindowController!
    private var window: NSWindow!
    var coordinators = [String: BaseCoordinator]()

    func start() {
        setupMainViewControllerStack()
    }


    private func setupMainViewControllerStack() {

        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        mainWindowController = storyboard.instantiateController(withIdentifier: "MainWindowController") as? NSWindowController
        window = mainWindowController.window

        guard let mainViewController = window.contentViewController as? MapListViewController else {
            fatalError("The Main View Controller Cannot be found");
        }

        let mainInteractor = MapListInteractor()
        mainInteractor.dataProvider = DataProvider()
        mainInteractor.coordinatorDelegate = self

        mainViewController.interactor = mainInteractor
        mainWindowController.showWindow(self)
    }
}


extension AppCoordinator: MapListControllerCoordinatorDelegate {

    func newMap() {
        print("AppCoordinator.newMap()")
        editMap(id: NSUUID().uuidString)
    }

    func editMap(id: String) {
        print("AppCoordinator.editMap(\(id))")
        guard let editCoordinator = coordinators[id] as? MapEditCoordinator else {

            let coordinator = MapEditCoordinator()
            coordinator.delegate = self
            coordinator.edit(id: id)
            coordinator.key = id
            coordinators[id] = coordinator
            return
        }

        editCoordinator.focus()
    }

    func previewMap(id: String, position: NSPoint, timeBasedDisplay: Bool = false) {
        print("AppCoordinator.previewMap(\(id))")
        /*let previewCoordinator = PreviewCoordinator()
        previewCoordinator.delegate = self
        previewCoordinator.start(id: id, position: position, timeBasedDisplay: timeBasedDisplay)
        coordinators[previewCoordinator.key] = previewCoordinator*/
    }
}


extension AppCoordinator: CoordinatorDelegate {

    func done(coordinator: Coordinator) {
        coordinators.removeValue(forKey: coordinator.key)
    }
}
