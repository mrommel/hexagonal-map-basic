//
//  MapCollectionViewItem.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 05.05.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation
import Cocoa
import HexagonalMap

protocol MapCollectionViewItemDelegate: class {
    
    func hover(collectionItem: MapCollectionViewItem, position: NSPoint)
    func doubleClicked(collectionItem: MapCollectionViewItem)
}

class MapCollectionViewItem: NSCollectionViewItem {
    
    @IBOutlet weak var titleField: NSTextField!
    @IBOutlet weak var contentField: NSTextField!
    
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
            titleField.stringValue = map.title
            contentField.stringValue = map.teaser
        } else {
            titleField.stringValue = "title"
            contentField.stringValue = "abc"
        }
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

