//
//  EmptyScene.swift
//  HexagonalMapBasic
//
//  Created by Michael Rommel on 28.04.17.
//  Copyright © 2017 MiRo. All rights reserved.
//

import Foundation
import SceneKit

class EmptyScene: SCNScene {
    
    let fixedCameraNode: SCNNode
    
    class func visibleCamera (_ fovDegrees: Double) -> SCNNode {
        let result = SCNNode()
        
        let shapeForCamera = SCNCone(topRadius: 0, bottomRadius: 0.1, height: 0.3)
        let shapeNode = SCNNode(geometry: shapeForCamera)
        result.addChildNode(shapeNode)
        // Make bottom of cone point along parent's -Z axis:
        shapeNode.rotation = SCNVector4Make(1, 0, 0, CGFloat(Float(M_PI_2)))
        
        let camera = SCNCamera()
        //        camera.usesOrthographicProjection = true
        camera.xFov = fovDegrees
        camera.yFov = fovDegrees
        // MARK: Camera near/far clipping. Uncomment both of these, then keep zNear but omit zFar:
        //		camera.zNear = 0.1
        //		camera.zFar = 2.00
        result.camera = camera
        
        return result
    }
    
    override init() {
        let objectSize = Float(0.5)
        let orbitRadius = 30 * objectSize
        let cameraFOVDegrees = 70.0
        
        fixedCameraNode = EmptyScene.visibleCamera(cameraFOVDegrees)
        fixedCameraNode.position = SCNVector3Make(CGFloat(-1.5 * orbitRadius), CGFloat(0.5 * orbitRadius), CGFloat(1.5 * orbitRadius))
        //fixedCameraNode.position = SCNVector3Make(0, 3 * carouselRadius, 0)
        
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
