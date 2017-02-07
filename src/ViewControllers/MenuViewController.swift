//
//  MenuViewController.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 06.02.17.
//  Copyright © 2017 MARK BROWNSWORD. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController {

    let menuEntries = ["New Game", "Setup Game", "Load Game", "Options", "Credits"]
    
    override func viewDidLoad() {
        self.title = "Game"
        self.tableView.tableFooterView = UIView()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuEntries.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil // "Section \(section)"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"TextCell", for: indexPath)
        let menuEntry = self.menuEntries[indexPath.row]
        cell.textLabel?.text = "\(menuEntry)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch(indexPath.row) {
        case 0:
            let gameViewController = GameViewController.instantiateFromStoryboard("Main")
            
            self.navigationController?.pushViewController(gameViewController, animated: true)
        default:
            return
        }
    }

}
