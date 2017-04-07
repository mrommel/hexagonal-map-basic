//
//  GameViewController.swift
//
//  Created by MARK BROWNSWORD on 24/7/16.
//  Copyright © 2016 MARK BROWNSWORD. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import SCLAlertView

class GameViewController: UIViewController {
    
    // MARK: Property Overrides
    
    var map: Map?
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    // MARK: Function overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let scene = GameScene(size: view.bounds.size)
        scene.onFocusChanged = { focus in
            if let focus = focus {
                if let city = self.map?.city(at: focus) {
                    self.showInfoFor(city: city)
                } else {
                    if let tile = self.map?.grid?.tile(at: focus) {
                        self.showInfoFor(tile: tile)
                    }
                }
            }
        }
        
        let skView = view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
                
        self.map = Map(width: 50, height: 50)
        self.map?.generate(withWaterPercentage: 0.4)
        
        /*self.map?.grid?.add(feature: Feature.forest, at: GridPoint(x: 2, y: 2))
        self.map?.grid?.add(feature: Feature.hill, at: GridPoint(x: 3, y: 2))
        self.map?.grid?.add(feature: Feature.hill, at: GridPoint(x: 2, y: 4))
        
        do {
            try self.map?.grid?.tileAt(x: 5, y: 6).setRiverFlowInNorth(flow: .west)
            try self.map?.grid?.tileAt(x: 5, y: 6).setRiverFlowInNorthEast(flow: .northWest)
            try self.map?.grid?.tileAt(x: 5, y: 6).setRiverFlowInSouthEast(flow: .northEast)
            try self.map?.grid?.tileAt(x: 6, y: 6).setRiverFlowInNorth(flow: .west)
        } catch {
            print("error while setting river: \(error)")
        }
        
        self.map?.foundCityAt(x: 6, y: 5, named: "Berlin")*/
        
        scene.map = self.map
        
        skView.presentScene(scene)
    }
    
    func showInfoFor(city: City) {
        SCLAlertView().showInfo("Important info", subTitle: "city")
    }
    
    func showInfoFor(tile: Tile) {
        
        var tileTxt = "x: \(tile.point.x), y: \(tile.point.y), "
        
        let continent = tile.continent
        if let continent = continent {
            tileTxt += "continent: \(continent), "
        }
        
        if tile.isRiver() {
            tileTxt += "river: \(tile.river?.name ?? "???"), flow:["
            if tile.isRiverInNorthEast() {
                tileTxt += "ne,"
            }
            if tile.isRiverInNorth() {
                tileTxt += "n,"
            }
            if tile.isRiverInSouthEast() {
                tileTxt += "se,"
            }
            tileTxt += "], "
        }
        
        SCLAlertView().showInfo("Important info", subTitle: tileTxt)
    }

    @IBAction func openMenu(sender: AnyObject) {
        
        let alertView = SCLAlertView()
        alertView.addButton("Turn") {
            print("Turn")
        }
        alertView.addButton("Exit Game") {
            print("Exit")
            self.goBack(animated: true)
        }
        alertView.showSuccess("Menu", subTitle: "Select one of the options")
    }
}
