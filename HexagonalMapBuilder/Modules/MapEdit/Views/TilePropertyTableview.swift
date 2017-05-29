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

class TilePropertyTableview: NSTableView {
    
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
         
        Swift.print("tableViewDoubleClick: \(tile) + \(row)")
    }
}

extension TilePropertyTableview: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return 3
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
