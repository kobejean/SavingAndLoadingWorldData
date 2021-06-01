//
//  ARGeoSession.swift
//  ARPersistence
//
//  Created by Jean Flaherty on 5/30/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation
import ARKit

class ARGeoSession: NSObject {
    var session: ARSession
    var locationManager = LocationManager()
    var trackingStatistics = ARGeoSessionTrackingStatistics()
    
    private var _sessionDelegateForwarder = ARSessionDelegateForwarder()
    weak var sessionDelegate: ARSessionDelegate? {
        set {
            _sessionDelegateForwarder.externalDelegate = newValue
            session.delegate = _sessionDelegateForwarder
        }
        get {
            return session.delegate
        }
    }
    
    func run(_ configuration: ARConfiguration, options: ARSession.RunOptions = []) {
        guard let configuration = configuration as? ARWorldTrackingConfiguration, configuration.worldAlignment == .gravityAndHeading else {
            fatalError("Configuration must be ARWorldTrackingConfiguration with worldAlignment == .gravityAndHeading")
        }
        session.run(configuration, options: options)
        locationManager.requestAuthorization()
        print("locationManager.requestAuthorization()")
    }
    
    // MARK: - Initialization
    
    init(session: ARSession) {
        self.session = session
        super.init()
        setup()
    }
    
    func setup() {
        // setup delegate forwarding
        _sessionDelegateForwarder.internalDelegate = self
        session.delegate = _sessionDelegateForwarder
        // setup other delegates
        locationManager.delegate = self
        trackingStatistics.delegate = self
    }
}

class ARSessionDelegateForwarder: DelegateForwarder<ARSessionDelegate>, ARSessionDelegate {}
