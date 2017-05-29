//
//  MapEditViewController.swift
//  HexagonalMapBuilder
//
//  Created by Michael Rommel on 19.04.17.
//  Copyright © 2017 MiRo Soft. All rights reserved.
//

import Cocoa
import Foundation
import SceneKit
import SpriteKit
import HexagonalMapKit


class MapEditViewController: NSViewController {

    @IBOutlet var sceneView: GameSceneView?
    @IBOutlet var statusLabel: NSTextField?
    @IBOutlet var propertyTable: TilePropertyTableview?
    
    var interactor: MapEditInteractorInput?
    var presenter: MapEditPresenterInput?
    
    var viewModel: MapEditViewModel?
}


/// Methods

extension MapEditViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear() {
        
        super.viewDidAppear()
        
        self.presenter?.setupUI()
        self.view.window?.delegate = self
    }
}

extension MapEditViewController: NSWindowDelegate {
    
    private func windowShouldClose(_ sender: Any) {
        
        // TODO let map list know that we are going to close
        print("debug -> let map list know, we are going to close")
    }
}

extension MapEditViewController: MapEditPresenterOutput {
    
    func setupUI(_ data: MapEditViewModel) {
        
        self.sceneView?.backgroundColor = .black
        
        self.sceneView?.onFocusChanged = { focus in
            if let focus = focus {
                self.statusLabel?.stringValue = "New focus: \(focus.x), \(focus.y)"
                
                if let model = self.viewModel {
                    if let map = model.map {
                        let focusTile = map.grid?.tile(at: focus)
                        self.showPropertiesFor(tile: focusTile)
                    }
                }
            }
        }
        
        self.propertyTable?.setup()
    }
    
    func refreshUI(_ data: MapEditViewModel) {
        
        self.viewModel = data
        self.sceneView?.map = self.viewModel?.map
    }
}

extension MapEditViewController {
    
    @IBAction func endEditingText(_ sender: AnyObject) {
        print("edit: \(sender)")
    }
    
    func showPropertiesFor(tile: Tile?) {
        
        self.propertyTable?.tileValue = tile
        
        self.propertyTable?.reloadData()
    }
}

/*

    @IBAction func saveMapSelected(_ sender: Any) {
        self.controller?.saveMap()
    }
    
    @IBAction func generateRandomMapSelected(_ sender: Any) {
        
        let options = GridGeneratorOptions(withSize: .test, zone: .earth, waterPercentage: 0.3, rivers: 5)
        self.controller?.generateMap(withOptions: options)
        self.refreshDisplay()
    }
}

extension MapEditViewController: MapEditControllerViewDelegate {
    
    func displayErrorMessage(editController: MapEditController, message: String) {
        
        guard let window = view.window else { return }

        let alert = NSAlert()
        alert.addButton(withTitle: "OK")
        alert.messageText = message
        alert.beginSheetModal(for: window, completionHandler: nil)
    }
}

*/
