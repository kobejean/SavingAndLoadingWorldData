//
//  ARGeoSession+ARGeoSessionTrackingStatisticsDelegate.swift
//  ARPersistence
//
//  Created by Jean Flaherty on 5/31/21.
//  Copyright © 2021 Apple. All rights reserved.
//
import Foundation
import ARKit

extension ARGeoSession: ARGeoSessionTrackingStatisticsDelegate {
    func locationAdded(location: CLLocation, to recordedGeoFrame: ARRecordedGeoFrame) {
        let locationAnchor = ARGeoAnchor(transform: recordedGeoFrame.transform, location: location)
        session.add(anchor: locationAnchor)
    }
}
