//
//  AStarPathfinder.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 10.02.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation
import HexagonalMapKit

/** A single step on the computed path; used by the A* pathfinding algorithm */
private class AStarPathStep: Hashable {
    let position: GridPoint
    var parent: AStarPathStep?
    
    var gScore = 0
    var hScore = 0
    var fScore: Int {
        return gScore + hScore
    }
    
    var hashValue: Int {
        return position.hashValue
    }
    
    init(position: GridPoint) {
        self.position = position
    }
    
    func setParent(parent: AStarPathStep, withMoveCost moveCost: Int) {
        // The G score is equal to the parent G score + the cost to move from the parent to it
        self.parent = parent
        self.gScore = parent.gScore + moveCost
    }
}

private func == (lhs: AStarPathStep, rhs: AStarPathStep) -> Bool {
    return lhs.position == rhs.position
}

extension AStarPathStep: CustomDebugStringConvertible {
    var debugDescription: String {
        return "AStarPathStep pos=\(position) g=\(gScore) h=\(hScore) f=\(fScore)"
    }
}

/** A pathfinder based on the A* algorithm to find the shortest path between two locations */
class AStarPathfinder {
    
    weak var dataSource: PathfinderDataSource!
    
    private func insertStep(step: AStarPathStep, inOpenSteps openSteps: inout [AStarPathStep]) {
        openSteps.append(step)
        openSteps = openSteps.sorted { return $0.fScore <= $1.fScore }
    }
    
    func hScoreFromCoord(fromCoord: GridPoint, toCoord: GridPoint) -> Int {
        return abs(toCoord.x - fromCoord.x) + abs(toCoord.y - fromCoord.y)
    }
    
    func shortestPathFromTileCoord(fromTileCoord: GridPoint, toTileCoord: GridPoint) -> [GridPoint]? {
        var closedSteps = Set<AStarPathStep>()
        
        // The open steps list is initialised with the from position
        var openSteps = [AStarPathStep(position: fromTileCoord)]
        
        while !openSteps.isEmpty {
            // remove the lowest F cost step from the open list and add it to the closed list
            // Because the list is ordered, the first step is always the one with the lowest F cost
            let currentStep = openSteps.remove(at: 0)
            closedSteps.insert(currentStep)
            
            // If the current step is the desired tile coordinate, we are done!
            if currentStep.position == toTileCoord {
                return convertStepsToShortestPath(lastStep: currentStep)
            }
            
            // Get the adjacent tiles coords of the current step
            let adjacentTiles = dataSource.walkableAdjacentTilesCoordsForTileCoord(tileCoord: currentStep.position)
            for tile in adjacentTiles {
                let step = AStarPathStep(position: tile)
                
                // check if the step isn't already in the closed list
                if closedSteps.contains(step) {
                    continue // ignore it
                }
                
                // Compute the cost from the current step to that step
                let moveCost = dataSource.costToMoveFromTileCoord(fromTileCoord: currentStep.position, toAdjacentTileCoord: step.position)
                
                // Check if the step is already in the open list
                if let existingIndex = openSteps.index(of: step) {
                    // already in the open list
                    
                    // retrieve the old one (which has its scores already computed)
                    let step = openSteps[existingIndex]
                    
                    // check to see if the G score for that step is lower if we use the current step to get there
                    if currentStep.gScore + moveCost < step.gScore {
                        // replace the step's existing parent with the current step
                        step.setParent(parent: currentStep, withMoveCost: moveCost)
                        
                        // Because the G score has changed, the F score may have changed too
                        // So to keep the open list ordered we have to remove the step, and re-insert it with
                        // the insert function which is preserving the list ordered by F score
                        openSteps.remove(at: existingIndex)
                        insertStep(step: step, inOpenSteps: &openSteps)
                    }
                    
                } else { // not in the open list, so add it
                    // Set the current step as the parent
                    step.setParent(parent: currentStep, withMoveCost: moveCost)
                    
                    // Compute the H score which is the estimated movement cost to move from that step to the desired tile coordinate
                    step.hScore = hScoreFromCoord(fromCoord: step.position, toCoord: toTileCoord)
                    
                    // Add it with the function which preserves the list ordered by F score
                    insertStep(step: step, inOpenSteps: &openSteps)
                }
            }
            
        }
        
        // no path found
        return nil
    }
    
    private func convertStepsToShortestPath(lastStep: AStarPathStep) -> [GridPoint] {
        var shortestPath = [GridPoint]()
        var currentStep = lastStep
        while let parent = currentStep.parent { // if parent is nil, then it is our starting step, so don't include it
            shortestPath.insert(currentStep.position, at: 0)
            currentStep = parent
        }
        return shortestPath
    }
}
