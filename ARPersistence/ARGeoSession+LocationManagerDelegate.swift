//
//  ARGeoSession+LocationManagerDelegate.swift
//  ARPersistence
//
//  Created by Jean Flaherty on 5/30/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation
import ARKit

extension ARGeoSession: LocationManagerDelegate {
    
    func locationManagerDidUpdateLocation(_ locationManager: LocationManager, location: CLLocation) {
        guard trackingStatistics.recordedFrames.count > 0 else { return }
        trackingStatistics.queuedlocations.enqueue(location)
    }
    
    func locationManagerDidUpdateHeading(_ locationManager: LocationManager, heading: CLHeading) {
        guard trackingStatistics.recordedFrames.count > 0 else { return }
        trackingStatistics.queuedHeadings.enqueue(heading)
    }
}
