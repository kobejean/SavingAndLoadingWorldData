//
//  ARGeoSCNView.swift
//  ARPersistence
//
//  Created by Jean Flaherty on 5/30/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation
import SceneKit
import ARKit


class ARGeoSCNView: ARSCNView {
    var geoSession: ARGeoSession!
    
    // MARK: - Delegate Forwarding
    
    internal var _delegateForwarder = ARSCNViewDelegateForwarder()
    override weak var delegate: ARSCNViewDelegate? {
        set {
            _delegateForwarder.externalDelegate = newValue
            super.delegate = _delegateForwarder
        }
        get {
            return super.delegate
        }
    }
    
    // MARK: - Initialization
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    override init(frame: CGRect, options: [String : Any]? = nil) {
        super.init(frame: frame, options: options)
        setup()
    }
    
    func setup() {
        _delegateForwarder.internalDelegate = self
        super.delegate = _delegateForwarder
        geoSession = ARGeoSession(session: session)
    }
}


class ARSCNViewDelegateForwarder: DelegateForwarder<ARSCNViewDelegate>, ARSCNViewDelegate {}
