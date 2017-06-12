//
//  MapCollectionViewItem.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 05.05.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation
import Cocoa
import HexagonalMapKit

protocol MapCollectionViewItemDelegate: class {
    
    func hover(collectionItem: MapCollectionViewItem, position: NSPoint)
    func doubleClicked(collectionItem: MapCollectionViewItem)
}

class MapCollectionViewItem: NSCollectionViewItem {
    
    @IBOutlet weak var titleField: NSTextField!
    @IBOutlet weak var contentField: NSTextField!
    @IBOutlet weak var imageField: NSImageView!
    
    weak var delegate: MapCollectionViewItemDelegate?
    
    var index: Int = 0
    
    var map: Map? {
        didSet {
            refreshDisplay()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.wantsLayer = true
        titleField.preferredMaxLayoutWidth = titleField.frame.size.width
        
        if let view = view as? HoverView {
            view.delegate = self
        }
    }
}


/// Display Functions
extension MapCollectionViewItem {
    
    func refreshDisplay() {
        setColors()
        if let map = self.map {
            self.titleField.stringValue = map.title
            self.contentField.stringValue = map.teaser
            self.imageField.image = self.imageOf(map: map)
        } else {
            self.titleField.stringValue = "title"
            self.contentField.stringValue = "abc"
            self.imageField.image = nil
        }
    }
    
    private func imageOf(map: Map) -> NSImage {
        
        let image = NSImage(size: NSSize(width: 125, height: 125))
        
        image.lockFocus()
        
        NSColor.black.set()
        NSRectFill(NSMakeRect(0, 0, 125, 125))
        
        image.unlockFocus()
        
        image.lockFocus()
        
        if let width = map.grid?.width, let height = map.grid?.height {
        
            for x in 0..<125 {
                for y in 0..<125 {
                    
                    let px = CGFloat(x) / 125.0 * CGFloat(width)
                    let py = CGFloat(y) / 125.0 * CGFloat(height)
                    
                    let terrain = map.grid?.tileAt(x: Int(px), y: Int(py)).terrain
                    
                    if let isWater = terrain?.isWater {
                        if isWater {
                            NSColor.blue.set()
                        } else {
                            NSColor.green.set()
                        }
                    } else {
                        NSColor.green.set()
                    }
                    NSRectFill(NSMakeRect(CGFloat(x), CGFloat(y), 1, 1))
                        
                }
            }
        }
        
        image.unlockFocus()
        
        return image
    }
    
    
    private func setColors() {
        
        view.layer?.backgroundColor = NSColor(red:0.98, green:0.98, blue:0.98, alpha:1.00).cgColor
        view.layer?.cornerRadius = 10.0
        
        if isSelected {
            view.layer?.borderColor = NSColor(red:0.24, green:0.44, blue:0.63, alpha:1.00).cgColor
            view.layer?.borderWidth = 2.0
        } else {
            view.layer?.borderColor = NSColor(red:0.95, green:0.95, blue:0.95, alpha:1.00).cgColor
            view.layer?.borderWidth = 1.0
        }
    }
}


/// HoverView Delegate
extension MapCollectionViewItem: HoverViewDelegate {
    
    func hover(view: HoverView, position: NSPoint) {
        delegate?.hover(collectionItem: self, position: position)
    }
    
    func doubleClick(view: HoverView) {
        delegate?.doubleClicked(collectionItem: self)
    }
}

