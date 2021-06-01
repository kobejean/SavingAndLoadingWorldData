//
//  ViewController+ARSCNViewDelegate.swift
//  ARPersistence
//
//  Created by Jean Flaherty on 5/28/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

extension ViewController: ARSCNViewDelegate {
    
    // MARK: - ARSCNViewDelegate
    
    /// - Tag: RestoreVirtualContent
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        print(anchor)
        guard anchor.name == virtualObjectAnchorName
            else { return }
        
        // save the reference to the virtual object anchor when the anchor is added from relocalizing
        if virtualObjectAnchor == nil {
            virtualObjectAnchor = anchor
        }
        node.addChildNode(virtualObject)
    }
    
//    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
//        guard let frame = sceneView.session.currentFrame,
//              let featurePointsArray = frame.rawFeaturePoints?.points else { return }
//        visualizeFeaturePointsIn(featurePointsArray)
//    }
//
//    func visualizeFeaturePointsIn(_ featurePointsArray: [vector_float3]) {
//        sceneView.scene.rootNode.enumerateChildNodes { (featurePoint, _) in
//            featurePoint.geometry = nil
//            featurePoint.removeFromParentNode()
//        }
//        featurePointsArray.forEach { (pointLocation) in
//            let clone = sphereNode.clone()
//            clone.position = SCNVector3(pointLocation.x, pointLocation.y, pointLocation.z)
//            sceneView.scene.rootNode.addChildNode(clone)
//        }
//    }
}
