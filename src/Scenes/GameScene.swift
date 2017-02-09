//
//  GameScene.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 08.02.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import UIKit
import SpriteKit

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func * (point: CGPoint, scalar: CGPoint) -> CGPoint {
    return CGPoint(x: point.x * scalar.x, y: point.y * scalar.y)
}

func / (point: CGPoint, scalar: CGPoint) -> CGPoint {
    return CGPoint(x: point.x / scalar.x, y: point.y / scalar.y)
}

enum Tile: Int {
    
    case Ocean
    case Grass
    
    var description:String {
        switch self {
        case .Ocean:
            return "Ocean"
        case .Grass:
            return "Grass"
        }
    }
    
    var image:String {
        switch self {
        case .Ocean:
            return "ocean"
        case .Grass:
            return "grass"
        }
    }
}

class GameScene: SKScene {
    
    var grid: Grid?
    
    //1
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //2
    let view2D: SKSpriteNode
    
    //3
    let tileSize = (width:32, height:32)
    
    //4
    override init(size: CGSize) {
        
        view2D = SKSpriteNode()
        
        super.init(size: size)
        self.anchorPoint = CGPoint(x:0.5, y:0.5)
    }
    
    //5
    override func didMove(to view: SKView) {
        
        let deviceScale = self.size.width/667
        
        view2D.position = CGPoint(x:-self.size.width*0.45, y:self.size.height*0.17)
        view2D.xScale = deviceScale
        view2D.yScale = deviceScale
        addChild(view2D)
        
        placeAllTiles2D()
    }
    
    func placeAllTiles2D() {
        
        let width: Int = (self.grid?.width)!
        let height: Int = (self.grid?.height)!
        
        for x in 0..<width {
            
            for y in 0..<height {
                
                let gridPoint = GridPoint(x: x, y: y)
                
                let point = self.grid?.screenPoint(from: gridPoint)
                
                let terrain = self.grid?.terrain(at: gridPoint)
                
                placeTile2D(image: (terrain?.terrainType.image)!, withPosition: point!)
            }
        }
    }
    
    func placeTile2D(image:String, withPosition:CGPoint) {
        
        let tileSprite = SKSpriteNode(imageNamed: image)
        
        tileSprite.position = withPosition
        
        tileSprite.anchorPoint = CGPoint(x:0, y:0)
        
        view2D.addChild(tileSprite)
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //////////////////////////////////////////////////////////
        // Original code that we still need
        //////////////////////////////////////////////////////////
        
        let touch = touches.first
        let touchLocation = touch?.location(in: self.view2D)
        
        let gridPoint = grid?.gridPoint(from: touchLocation!)
        
        NSLog("touch \(gridPoint)")
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        //NSLog("update")
    }
}
