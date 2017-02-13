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
    var cam: SKCameraNode!
    
    let view2D: SKSpriteNode
    let layer2DHighlight: SKNode
    var cursor: SKSpriteNode
    
    let tileSize = (width:64, height:64)
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(size: CGSize) {
        
        self.view2D = SKSpriteNode()
        self.layer2DHighlight = SKNode()
        self.cursor = SKSpriteNode(imageNamed: "Selection")
        
        super.init(size: size)
        self.anchorPoint = CGPoint(x:0.5, y:0.5)
    }

    override func didMove(to view: SKView) {
        
        let deviceScale = self.size.width / 667
        
        self.view2D.position = CGPoint(x:-self.size.width*0.45, y:self.size.height*0.17)
        self.view2D.xScale = deviceScale
        self.view2D.yScale = deviceScale
        self.addChild(view2D)
        
        self.layer2DHighlight.zPosition = 999
        self.view2D.addChild(self.layer2DHighlight)
        
        self.placeAllTiles2D()
        
        self.cam = SKCameraNode() //initialize and assign an instance of SKCameraNode to the cam variable.
        self.cam.xScale = 1 // 0.25
        self.cam.yScale = 1 // 0.25 //the scale sets the zoom level of the camera on the given position
        
        self.camera = cam //set the scene's camera to reference cam
        self.addChild(cam) //make the cam a childElement of the scene itself.
        
        //position the camera on the gamescene.
        self.cam.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        // cursor
        self.cursor.anchorPoint = CGPoint(x: 0, y: 0)
        self.layer2DHighlight.addChild(self.cursor)
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
        
        self.view2D.addChild(tileSprite)
    }
    
    func moveFocus(to gridpoint: GridPoint) {

        self.cursor.position = (self.grid?.screenPoint(from: gridpoint))!
    }
    
    // handling touches
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        let touchLocation = touch?.location(in: self.view2D)
        
        let gridPoint = self.grid?.gridPoint(from: touchLocation!)
        
        NSLog("touch hex: \(gridPoint)")
        
        // update the rendering
        self.moveFocus(to: gridPoint!)
        
        // notify parent
        if let focusChanged = self.onFocusChanged {
            focusChanged(gridPoint)
        }
    }
    
    // moving the map around
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self.view2D)
            let previousLocation = touch.previousLocation(in: self.view2D)
            let deltaX = (location.x) - (previousLocation.x)
            let deltaY = (location.y) - (previousLocation.y)
            //NSLog("deltaX=\(deltaX), deltaY=\(deltaY)")
            self.cam.position.x -= deltaX * 0.5
            self.cam.position.y -= deltaY * 0.5
        }
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        //NSLog("update")
    }
}
