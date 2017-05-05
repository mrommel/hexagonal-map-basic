//
//  MapEditController.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 05.05.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation

import Foundation

protocol MapEditControllerViewDelegate: class {
    
    func mapDidChange(editController: MapEditController)
    func displayErrorMessage(editController: MapEditController, message: String)
}

protocol MapEditController: class {
    
    var viewDelegate: MapEditControllerViewDelegate? {get set}
    //var noteValues: (title: String, content: NSAttributedString) { get }
    
    //func updateNoteValues(title: String, content: NSAttributedString)
    //func canSaveNoteValues(title: String, content: NSAttributedString) -> Bool
    func cancel()
}
