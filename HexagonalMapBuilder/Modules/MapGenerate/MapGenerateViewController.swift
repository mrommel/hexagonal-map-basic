//
//  MapGenerateViewController.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 02.06.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Cocoa
import Foundation

class MapGenerateViewController: NSViewController {
    
    var interactor: MapGenerateInteractorInput?

}

extension MapGenerateViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func generateSelected(_ sender: Any) {
        
        Swift.print("=> generate")

        self.interactor?.startMapGeneration()
    }
}

extension MapGenerateViewController: MapGeneratePresenterOutput {
    
    func setupUI(_ data: MapGenerateViewModel) {
        Swift.print("=> setupUI")
    }
    
    func refreshUI(_ data: MapGenerateViewModel) {
        Swift.print("=> refreshUI")
    }
}
