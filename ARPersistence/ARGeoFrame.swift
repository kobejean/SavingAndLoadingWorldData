//
//  ARGeoFrame.swift
//  ARPersistence
//
//  Created by Jean Flaherty on 5/30/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation
import ARKit
import CoreLocation

struct ARRecordedGeoFrame {
    var timestamp: TimeInterval
    var transform: simd_float4x4
    var eulerAngles: simd_float3
    var heading: CLLocationDirection? = nil
    var location: CLLocation? = nil
}
