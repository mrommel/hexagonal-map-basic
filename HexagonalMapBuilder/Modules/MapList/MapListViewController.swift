//
//  MainViewController.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 05.05.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Cocoa
import Foundation
import HexagonalMapKit

/// Used to make identifiying MenuItems a little easier to read in code.
/// Menu Items should have their Tag value set to the corresponding value
enum MenuTag: Int {
    case NewMenu = 100
    case OpenMenu = 110
    case SaveMenu = 120
    case ShowFonts = 300
}

class MapListViewController: NSViewController {
    
    static let collectionCellIdentifier = "MapItemCell"
    
    @IBOutlet weak var collectionView: NSCollectionView!
    @IBOutlet weak var addButton: NSButton!
    
    var lastPreviewIndex: Int = -1
    
    var interactor: MapListInteractorInput?
    var presenter: MapListPresenterInput?
    
    var viewModel: MapListViewModel?
}

/// Methods

extension MapListViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear() {
        
        super.viewDidAppear()
        
        self.presenter?.setupUI()
        self.view.window?.delegate = self
    }
}

extension MapListViewController: NSWindowDelegate {
    
    public func windowWillClose(_ notification: Notification) {
        
        // TODO prevent closing main window when there are child windows
        // TODO regain delegate when child is closed
        NSApplication.shared().terminate(self)
    }
}

extension MapListViewController: MapListPresenterOutput {
    
    func setupUI(_ data: MapListViewModel) {
        
        self.viewModel = data
        
        self.title = viewModel?.title!
        setUpCollectionView()
    }
    
    func refreshUI(_ data: MapListViewModel) {
        
        self.viewModel = data
        collectionView.reloadData()
    }

}

extension MapListViewController {
    
    func setUpCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.itemSize = NSSize(width: 420.0, height: 120.0)
        flowLayout.sectionInset = EdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0)
        flowLayout.minimumInteritemSpacing = 5.0
        flowLayout.minimumLineSpacing = 10.0
        collectionView.collectionViewLayout = flowLayout
        view.wantsLayer = true
    }
    
    func updateSelection(indexPaths: Set<IndexPath>) {
        for indexPath in indexPaths {
            if let note = collectionView.item(at: indexPath) as? MapCollectionViewItem {
                note.refreshDisplay()
                lastPreviewIndex = indexPath.item
            }
        }
    }
    
    func editMap(index: Int) {
        guard let interactor = self.interactor else { return }
        lastPreviewIndex = index
        interactor.editMap(index: index)
    }
}


/// Menu Methods
extension MapListViewController {
    
    // Handles the + button and the "New" Menu Item
    @IBAction func newDocument(sender: AnyObject) {
        
        self.interactor?.newMap()
    }
    
    @IBAction func openDocument(sender: AnyObject) {
        
        for selectedIndex in collectionView.selectionIndexes {
            editMap(index: selectedIndex)
        }
    }
    
    
    override func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
        
        switch (menuItem.tag) {
        case MenuTag.NewMenu.rawValue:
            return true
        case MenuTag.OpenMenu.rawValue:
            return collectionView.selectionIndexes.count > 0
        default:
            return false
        }
    }
}


/// Handle methods delegated from the controller
extension MapListViewController: MapListInteractorOutput {

    func onMapsLoaded() {
        print("MapListViewController.onMapsLoaded")
        //refreshUI()
    }
}


extension MapListViewController: NSCollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: NSCollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let viewModel = self.viewModel else { return 0 }
        guard let maps = viewModel.maps else { return 0 }
        
        return maps.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        
        let item = collectionView.makeItem(withIdentifier: "MapCollectionViewItem", for: indexPath)
        
        guard let viewModel = self.viewModel else { return item }
        guard let maps = viewModel.maps else { return item }
        
        if let item = item as? MapCollectionViewItem {
            let map = maps[indexPath.item]
            item.index = indexPath.item
            item.delegate = self
            item.map = map
        }
        
        return item
    }
}


extension MapListViewController: NSCollectionViewDelegate {
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        updateSelection(indexPaths: indexPaths)
    }
    
    func collectionView(_ collectionView: NSCollectionView, didDeselectItemsAt indexPaths: Set<IndexPath>) {
        updateSelection(indexPaths: indexPaths)
    }
}


extension MapListViewController: MapCollectionViewItemDelegate {
    
    func deleted(collectionItem: MapCollectionViewItem) {
        
        if let mapIdentifier = collectionItem.map?.id {
            Swift.print("delete \(mapIdentifier)")
            self.interactor?.deleteMapWith(identifier: mapIdentifier)
        }
    }

    func hover(collectionItem: MapCollectionViewItem, position: NSPoint) {
        
        let index = collectionItem.index
        guard lastPreviewIndex != index else { return }
        lastPreviewIndex = index
        
        //self.interactor?.previewMap(index: collectionItem.index, position: position)
    }
    
    
    func doubleClicked(collectionItem: MapCollectionViewItem) {
        
        editMap(index: collectionItem.index)
    }
}
