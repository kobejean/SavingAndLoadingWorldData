//
//  ARGeoSession+ARSessionDelegate.swift
//  ARPersistence
//
//  Created by Jean Flaherty on 5/30/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation
import ARKit

extension ARGeoSession: ARSessionDelegate {
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        print(camera.trackingState)
        switch camera.trackingState {
            case .limited(_):
                trackingStatistics.reset()
                break
            default: break
        }
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        if case .limited(_) = frame.camera.trackingState { return }
        
        let recordedFrame = ARRecordedGeoFrame(
            timestamp: frame.timestamp,
            transform: frame.camera.transform,
            eulerAngles: frame.camera.eulerAngles
        )
        trackingStatistics.aggregateTrackingStatistics(recordedFrame: recordedFrame)
        
    }
}
