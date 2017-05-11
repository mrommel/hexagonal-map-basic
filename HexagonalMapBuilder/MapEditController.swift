//
//  MapEditController.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 05.05.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation
import HexagonalMapKit

protocol MapEditControllerViewDelegate: class {
    
    func mapDidChange(editController: MapEditController)
    func displayErrorMessage(editController: MapEditController, message: String)
}

protocol MapEditController: class {
    
    var viewDelegate: MapEditControllerViewDelegate? { get set }
    var map: Map? { get }
    
    func cancel()
}
