//
//  ARGeoSCNView+ARSCNViewDelegate.swift
//  ARPersistence
//
//  Created by Jean Flaherty on 5/30/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

extension ARGeoSCNView: ARSCNViewDelegate {
    
    static private let _locationDot: SCNNode = {
        let sphereNode = SCNNode()
        let sphereGeometry = SCNSphere(radius: 0.005)
        sphereGeometry.firstMaterial?.diffuse.contents = UIColor.cyan
        sphereNode.geometry = sphereGeometry
        return sphereNode
    }()
    
    static private let _featurePointDot: SCNNode = {
        let sphereNode = SCNNode()
        let sphereGeometry = SCNSphere(radius: 0.001)
        sphereGeometry.firstMaterial?.diffuse.contents = UIColor.green
        sphereNode.geometry = sphereGeometry
        return sphereNode
    }()
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        if let node = _delegateForwarder.externalDelegate?.renderer?(renderer, nodeFor: anchor) {
            return node
        }
        
        switch anchor {
            case let geoAnchor as ARGeoAnchor:
                return nodeForGeoAnchor(anchor: geoAnchor)
            default:
                return SCNNode()
        }
    }
    
    func nodeForGeoAnchor(anchor: ARGeoAnchor) -> SCNNode {
        let node = Self._locationDot.clone()
        node.transform = SCNMatrix4(anchor.transform)
        return node
    }
}
