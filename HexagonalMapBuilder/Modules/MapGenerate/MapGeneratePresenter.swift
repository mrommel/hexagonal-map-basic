//
//  MapGeneratePresenter.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 02.06.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation

protocol MapGeneratePresenterOutput: class {
    
    func setupUI(_ data: MapGenerateViewModel)
    func refreshUI(_ data: MapGenerateViewModel)
}

class MapGeneratePresenter {
 
    weak var userInterface: MapGeneratePresenterOutput?
    var interactor: MapGenerateInteractorInput?
}
