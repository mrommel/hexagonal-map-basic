//
//  TilePropertyTableview.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 29.05.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation
import Cocoa
import HexagonalMapKit

protocol TilePropertyTableviewOutput: class {
    
    func tileChanged()
}

class TilePropertyTableview: NSTableView {
    
    var tilePropertyDelegate: TilePropertyTableviewOutput?
    
    var tileValue: Tile? {
        didSet {
            self.reloadData()
        }
    }
    
    func setup() {
        self.delegate = self
        self.dataSource = self
        
        self.target = self
        self.doubleAction = #selector(tableViewDoubleClick(_:))
    }
    
    public func tableViewDoubleClick(_ sender:AnyObject) {
        
        let row = self.selectedRow
        
        guard row >= 0, let tile = self.tileValue else {
            return
        }
        
        // only some value can be changed
        guard row == 1 else {
            Swift.print("It is not allowed to change row: \(row)")
            return
        }
         
        //Swift.print("tableViewDoubleClick: \(tile), row: \(row)")
        
        let alert = NSAlert()
        alert.messageText = "Please enter a value"
        alert.addButton(withTitle: "Save")
        alert.addButton(withTitle: "Cancel")
        
        let inputComboBox = NSComboBox(frame: NSRect(x: 0, y: 0, width: 300, height: 24))
        
        switch(row) {
        case 1: // terrain            
            inputComboBox.addItem(withObjectValue: "ocean")
            inputComboBox.addItem(withObjectValue: "shore")
            inputComboBox.addItem(withObjectValue: "grass")
            inputComboBox.addItem(withObjectValue: "plains")
            inputComboBox.addItem(withObjectValue: "desert")
            inputComboBox.addItem(withObjectValue: "tundra")
            inputComboBox.addItem(withObjectValue: "snow")
            inputComboBox.selectItem(withObjectValue: tile.terrain?.stringValue)
            alert.accessoryView = inputComboBox
            break
        default:
            break
        }
        
        alert.layout()

        alert.beginSheetModal(for: self.window!, completionHandler: { (modalResponse) -> Void in
            if modalResponse == NSAlertFirstButtonReturn {
                if let selection = inputComboBox.objectValueOfSelectedItem {
                    //Swift.print("selected value = \"\(selection)\"")
                    
                    switch(row) {
                    case 1: // terrain
                        tile.terrain = Terrain.enumFrom(string: selection as! String)
                        break
                    default:
                        break
                    }

                    // let parent know and redraw the map
                    if let tilePropertyDelegate = self.tilePropertyDelegate {
                        tilePropertyDelegate.tileChanged()
                    }
                }
            }
        })
    }
}

extension TilePropertyTableview: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return 6
    }
    
}

extension TilePropertyTableview: NSTableViewDelegate {
    
    fileprivate enum CellIdentifiers {
        static let IconCell = "IconCellID"
        static let NameCell = "NameCellID"
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        var image: NSImage?
        var text: String = ""
        var cellIdentifier: String = ""
        
        guard let tile = self.tileValue else {
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
        case 3:
            if tableColumn == tableView.tableColumns[0] {
                image = NSImage(named: "FeatureIcon")
                cellIdentifier = CellIdentifiers.IconCell
            } else if tableColumn == tableView.tableColumns[1] {
                text = tile.features.count > 0 ? tile.features[0].name : "no feature"
                cellIdentifier = CellIdentifiers.NameCell
            }
            break
        case 4:
            if tableColumn == tableView.tableColumns[0] {
                image = NSImage(named: "FeatureIcon")
                cellIdentifier = CellIdentifiers.IconCell
            } else if tableColumn == tableView.tableColumns[1] {
                text = tile.features.count > 1 ? tile.features[1].name : "no feature"
                cellIdentifier = CellIdentifiers.NameCell
            }
            break
        case 5:
            if tableColumn == tableView.tableColumns[0] {
                image = NSImage(named: "FeatureIcon")
                cellIdentifier = CellIdentifiers.IconCell
            } else if tableColumn == tableView.tableColumns[1] {
                text = tile.features.count > 2 ? tile.features[2].name : "no feature"
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
