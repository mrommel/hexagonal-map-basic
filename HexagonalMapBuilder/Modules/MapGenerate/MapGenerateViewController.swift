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
    
    @IBOutlet var sizeCombo: NSComboBox?
    @IBOutlet var climateCombo: NSComboBox?
    
    var interactor: MapGenerateInteractorInput?
    var presenter: MapGeneratePresenterInput?
    var viewModel: MapGenerateViewModel?
}

extension MapGenerateViewController {

    override func viewDidAppear() {
        super.viewDidAppear()
        
        self.presenter?.setupUI()
        self.view.window?.delegate = self
    }

    @IBAction func generateSelected(_ sender: Any) {
        
        Swift.print("=> generate")

        if let sizeData = self.sizeCombo?.objectValueOfSelectedItem, let climateData = self.climateCombo?.objectValueOfSelectedItem {
        
            Swift.print("sizeData: \(sizeData), climateData: \(climateData)")
            self.interactor?.startMapGeneration()
            
        } else {
            Swift.print("no items selected")
        }
    }
}

extension MapGenerateViewController: NSWindowDelegate {
    
    //private func windowShouldClose(_ sender: Any) {
    public func windowWillClose(_ notification: Notification) {
    
        // TODO let map list know that we are going to close
        print("debug -> let map edit know, we are going to close")
    }
}

extension MapGenerateViewController: MapGeneratePresenterOutput {
    
    func setupUI(_ data: MapGenerateViewModel) {
        self.viewModel = data
    }
    
    func refreshUI(_ data: MapGenerateViewModel) {
        Swift.print("=> refreshUI")
        self.viewModel = data
    }
}
