//
//  TileTests.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 27.02.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import XCTest
@testable import HexagonalMapBasic

class TileTests: XCTestCase {
    
    func testRiverDefaultsToFalse() {
     
        // Preconditions
        let tile = Tile(at: GridPoint(x: 0, y: 0), withTerrain: Terrain.grass)
        
        // Stimulus
        let isRiver = tile.isRiver()
        
        // Assertion
        XCTAssertEqual(isRiver, false, "river should default to false")
    }
    
    func testRiverInNorthFlowingEast() {
        
        // Preconditions
        let tile = Tile(at: GridPoint(x: 0, y: 0), withTerrain: Terrain.grass)
        
        do {
            try tile.setRiver(flow: .east, in: .north)
        } catch {
            XCTFail()
        }
        
        // Stimulus
        let isRiver = tile.isRiver()
        
        // Assertion
        XCTAssertEqual(isRiver, true, "river should default to false")
    }
    
    func testRiverInNorthFlowingWest() {
        
        // Preconditions
        let tile = Tile(at: GridPoint(x: 0, y: 0), withTerrain: Terrain.grass)
        
        do {
            try tile.setRiver(flow: .west, in: .north)
        } catch {
            XCTFail()
        }
        
        // Stimulus
        let isRiver = tile.isRiver()
        
        // Assertion
        XCTAssertEqual(isRiver, true, "river should default to false")
    }
    
    func testRiverFlowInNorthFlowingEast() {
        
        // Preconditions
        let tile = Tile(at: GridPoint(x: 0, y: 0), withTerrain: Terrain.grass)
        
        do {
            try tile.setRiverFlowInNorth(flow: .east)
        } catch {
            XCTFail()
        }
        
        // Stimulus
        let isRiver = tile.isRiver()
        
        // Assertion
        XCTAssertEqual(isRiver, true, "river should default to false")
    }
    
    func testRiverFlowInNorthFlowingWest() {
        
        // Preconditions
        let tile = Tile(at: GridPoint(x: 0, y: 0), withTerrain: Terrain.grass)
        
        do {
            try tile.setRiverFlowInNorth(flow: .west)
        } catch {
            XCTFail()
        }
        
        // Stimulus
        let isRiver = tile.isRiver()
        
        // Assertion
        XCTAssertEqual(isRiver, true, "river should default to false")
    }
    
    func testRiverFlowInNorthExpect() {
        
        // Preconditions
        let tile = Tile(at: GridPoint(x: 0, y: 0), withTerrain: Terrain.grass)
        
        do {
            // Stimulus
            try tile.setRiverFlowInNorth(flow: .northEast)
        } catch let e as FlowDirectionError {
            XCTAssertEqual(e, FlowDirectionError.Unsupported(flow: .northEast, in: .north), "wrong flow for direction")
        } catch {
            XCTFail("Wrong error")
        }
    }
    
    func testFlows() {
        
        // Preconditions
        let tile = Tile(at: GridPoint(x: 0, y: 0), withTerrain: Terrain.grass)
        try! tile.setRiverFlowInNorth(flow: .west)
        try! tile.setRiverFlowInNorthEast(flow: .northWest)
        
        // Stimulus
        let flows = tile.flows
        
        // Assertion
        XCTAssertEqual(flows.count, 2, "wrong number of flows")
        XCTAssertEqual(flows.contains(where: { $0 == .west }), true, "flows should contain .west")
        XCTAssertEqual(flows.contains(where: { $0 == .northWest }), true, "flows should contain .northWest")
    }
}
