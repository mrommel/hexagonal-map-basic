//
//  HoverView.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 05.05.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation
import Cocoa

protocol HoverViewDelegate: class {
    
    func hover(view: HoverView, position: NSPoint)
    func doubleClick(view: HoverView)
}

class HoverView: NSView {
    
    var trackingArea: NSTrackingArea?
    var hovering = false
    var timer: Timer?
    weak var delegate: HoverViewDelegate?
    var mousePosition: NSPoint?
}


/// Methods
extension HoverView {
    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        ensureTrackingArea()
        if !trackingAreas.contains(trackingArea!) {
            addTrackingArea(trackingArea!)
        }
    }
    
    
    func ensureTrackingArea()
    {
        guard trackingArea == nil else { return }
        trackingArea = NSTrackingArea(rect: NSZeroRect, options: [NSTrackingAreaOptions.inVisibleRect, NSTrackingAreaOptions.activeAlways, NSTrackingAreaOptions.mouseEnteredAndExited, NSTrackingAreaOptions.mouseMoved], owner: self, userInfo: nil)
    }
    
    
    private func cycleTimer()
    {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.5, target:self, selector: #selector(hover), userInfo: nil, repeats: false)
    }
    
    
    override func mouseEntered(with event: NSEvent) {
        cycleTimer()
    }
    
    
    override func mouseMoved(with event: NSEvent)
    {
        if timer != nil {
            cycleTimer()
        }
        mousePosition = NSEvent.mouseLocation()
    }
    
    
    override func mouseExited(with event: NSEvent)
    {
        timer?.invalidate()
        timer = nil
        hovering = false
    }
    
    
    override func mouseDown(with event: NSEvent)
    {
        let count = event.clickCount
        if (count == 2) {
            delegate?.doubleClick(view: self)
        } else {
            super.mouseDown(with: event)
        }
    }
    
    
    func hover()
    {
        hovering = true
        if let position = mousePosition {
            delegate?.hover(view: self, position: position)
        }
    }
}
