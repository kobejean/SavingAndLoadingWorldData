//
//  ARGeoAnchor.swift
//  ARPersistence
//
//  Created by Jean Flaherty on 5/31/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation
import ARKit
import CoreLocation

class ARGeoAnchor: ARAnchor {
    enum CoderKeys: String {
      case location = "location"
    }
    
    var location: CLLocation
    
    override func encode(with coder: NSCoder) {
        coder.encode(location, forKey: CoderKeys.location.rawValue)
    }
    
    // MARK: - Initialization
    
    init(transform: simd_float4x4, location: CLLocation) {
        self.location = location
        super.init(transform: transform)
    }
    
    required init?(coder: NSCoder) {
        guard let location = coder.decodeObject(of: CLLocation.self, forKey: CoderKeys.location.rawValue) else { return nil }
        self.location = location
        super.init(coder: coder)
    }
    
    required init(anchor: ARAnchor) {
        let other = anchor as! ARGeoAnchor
        self.location = other.location
        super.init(anchor: anchor)
    }
}
