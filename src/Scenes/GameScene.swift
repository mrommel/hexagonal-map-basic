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

typealias FocusChangedBlock = (_ focus: GridPoint?) -> Void

class GameScene: SKScene {
    
    var grid: Grid?
    var onFocusChanged: FocusChangedBlock?
    var onTileSelected: FocusChangedBlock?
    
    //1
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //2
    let view2D: SKSpriteNode
    let layer2DHighlight: SKNode
    
    //3
    let tileSize = (width:64, height:64)
    
    //4
    override init(size: CGSize) {
        
        view2D = SKSpriteNode()
        layer2DHighlight = SKNode()
        
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
        
        layer2DHighlight.zPosition = 999
        view2D.addChild(layer2DHighlight)
        
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
    
    func placeTile2D(image: String, withPosition: CGPoint) {
        
        let tileSprite = SKSpriteNode(imageNamed: image)
        
        tileSprite.position = withPosition
        
        tileSprite.anchorPoint = CGPoint(x:0, y:0)
        
        view2D.addChild(tileSprite)
    }
    
    func moveFocus(to gridpoint: GridPoint) {
        //clear previous focus
        layer2DHighlight.removeAllChildren()
        
        let focusTile = SKSpriteNode(imageNamed: "Selection")
        focusTile.position = (self.grid?.screenPoint(from: gridpoint))!
        focusTile.anchorPoint = CGPoint(x: 0, y: 0)
        
        layer2DHighlight.addChild(focusTile)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        let touchLocation = touch?.location(in: self.view2D)
        
        let gridPoint = grid?.gridPoint(from: touchLocation!)
        
        NSLog("touch \(gridPoint)")
        
        // update the rendering
        self.moveFocus(to: gridPoint!)
        
        // notify parent 
        if let focusChanged = self.onFocusChanged {
            focusChanged(gridPoint)
        }
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        //NSLog("update")
    }
}
