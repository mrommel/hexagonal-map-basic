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
    
    func display(error: Error) {
        
        guard let window = view.window else { return }
        
        let alert = NSAlert()
        alert.addButton(withTitle: "Okay")
        alert.messageText = error.localizedDescription
        alert.beginSheetModal(for: window, completionHandler: nil)
    }
    
    func display(title: String, message: String) {
        
        guard let window = view.window else { return }
        
        let alert = NSAlert()
        alert.addButton(withTitle: "Okay")
        alert.messageText = title
        alert.informativeText = message
        alert.beginSheetModal(for: window, completionHandler: nil)
    }
    
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
        self.propertyTable?.tilePropertyDelegate = self
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

extension MapEditViewController: TilePropertyTableviewOutput {
    
    func tileChanged() {
        self.sceneView?.map = self.viewModel?.map
    }
}

extension MapEditViewController {
    
    @IBAction func saveMapSelected(_ sender: Any) {
        
        self.interactor?.save(map: self.viewModel?.map)
    }
    
    @IBAction func closeMapSelected(_ sender: Any) {
        
        guard let window = view.window else { return }
        
        let alert = NSAlert()
        alert.addButton(withTitle: "Continue")
        alert.addButton(withTitle: "Save")
        alert.messageText = "Do you want to save?"
        alert.beginSheetModal(for: window, completionHandler: { response in
            if response == 1001 {
                self.interactor?.save(map: self.viewModel?.map)
            } else {
                self.interactor?.closeWindow()
            }
        })
    }
    
    @IBAction func generateRandomMapSelected(_ sender: Any) {
        
        self.interactor?.showGenerateDialog()
        
        /*let options = GridGeneratorOptions(withSize: .test, zone: .earth, waterPercentage: 0.3, rivers: 5)
        self.controller?.generateMap(withOptions: options)
        let tmp = Map(withOptions: options, completionHandler: { progress in
            print("generateMap => \(progress)")
        })
        
        tmp.id = self.id
        tmp.title = "Generated \(options.mapSize.width)x\(options.mapSize.height)"
        tmp.teaser = "Climate: \(options.climateZoneOption), Water: \(options.waterPercentage*100)%"
        
        self.map = tmp*/
    }
}
