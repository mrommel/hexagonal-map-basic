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
    @IBOutlet var propertyTable: NSTableView?
    var tile: Tile?

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
        self.sceneView?.backgroundColor = .black

        if let map = self.controller?.map {
            self.statusLabel?.stringValue = "Loaded: \(map.title)"
        }
        
        self.sceneView?.onFocusChanged = { focus in
            if let focus = focus {
                self.statusLabel?.stringValue = "New focus: \(focus.x), \(focus.y)"
                
                if let map = self.controller?.map {
                    let focusTile = map.grid?.tile(at: focus)
                    self.showPropertiesFor(tile: focusTile)
                }
            }
        }
        
        self.propertyTable?.target = self
        self.propertyTable?.doubleAction = #selector(tableViewDoubleClick(_:))
    }
    
    func showPropertiesFor(tile: Tile?) {
        
        self.tile = tile
        
        self.propertyTable?.reloadData()
    }

    func refreshDisplay() {
        self.sceneView?.map = self.controller?.map
    }
    
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


    func mapDidChange(editController: MapEditController) {
        self.refreshDisplay()
    }
}

extension MapEditViewController {
    
    public func tableViewDoubleClick(_ sender:AnyObject) {
        
        guard let row = self.propertyTable?.selectedRow else {
            return
        }
        
        guard row >= 0, let tile = self.tile else {
            return
        }
        
        print("tableViewDoubleClick: \(tile) + \(row)")
        
        /*if item.isFolder {
            // 2
            self.representedObject = item.url as Any
        }*/
    }
    
    @IBAction func endEditingText(_ sender: AnyObject) {
        print("edit: \(sender)")
    }
}

extension MapEditViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return 3
    }
    
}

extension MapEditViewController: NSTableViewDelegate {
    
    fileprivate enum CellIdentifiers {
        static let IconCell = "IconCellID"
        static let NameCell = "NameCellID"
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        var image: NSImage?
        var text: String = ""
        var cellIdentifier: String = ""
        
        guard let tile = self.tile else {
            return nil
        }
        
        switch(row) {
        case 0:
            if tableColumn == tableView.tableColumns[0] {
                image = NSImage(named: "PointIcon")
                cellIdentifier = CellIdentifiers.IconCell
            } else if tableColumn == tableView.tableColumns[1] {
                text = "\(tile.point.x), \(tile.point.y)"
                cellIdentifier = CellIdentifiers.NameCell
            }
            break
        case 1:
            if tableColumn == tableView.tableColumns[0] {
                image = NSImage(named: "TerrainIcon")
                cellIdentifier = CellIdentifiers.IconCell
            } else if tableColumn == tableView.tableColumns[1] {
                text = tile.terrain?.name ?? "no name"
                cellIdentifier = CellIdentifiers.NameCell
            }
            break
        case 2:
            if tableColumn == tableView.tableColumns[0] {
                image = NSImage(named: "ContinentIcon")
                cellIdentifier = CellIdentifiers.IconCell
            } else if tableColumn == tableView.tableColumns[1] {
                text = tile.continent?.name ?? "no continent"
                cellIdentifier = CellIdentifiers.NameCell
            }
            break
        default:
            break
        }
        
        
        if let cell = tableView.make(withIdentifier: cellIdentifier, owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            cell.imageView?.image = image ?? nil
            return cell
        }
        
        return nil
    }
    
}
