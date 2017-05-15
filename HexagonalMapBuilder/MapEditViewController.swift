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
    

    var controller: MapEditController? {
        willSet {
            controller?.viewDelegate = nil
        }
        didSet {
            controller?.viewDelegate = self
            refreshDisplay()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.sceneView?.backgroundColor = .brown

        if let map = self.controller?.map {
            self.statusLabel?.stringValue = "Loaded: \(map.title)"
        }
        
        self.sceneView?.onFocusChanged = { focus in
            if let focus = focus {
                self.statusLabel?.stringValue = "New focus: \(focus.x), \(focus.y)"
            }
        }
    }

    func refreshDisplay() {
        self.sceneView?.map = self.controller?.map
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


    func mapDidChange(editController: MapEditController) {
        self.refreshDisplay()
    }
}

