//
//  LocationManager.swift
//  ARPersistence
//
//  Created by Jean Flaherty on 5/30/21.
//  Copyright © 2021 Apple. All rights reserved.
//


import Foundation
import CoreLocation

protocol LocationManagerDelegate: AnyObject {
    func locationManagerDidUpdateLocation(_ locationManager: LocationManager,
                                          location: CLLocation)
    func locationManagerDidUpdateHeading(_ locationManager: LocationManager,
                                         heading: CLHeading)
}

extension LocationManagerDelegate {
    func locationManagerDidUpdateLocation(_ locationManager: LocationManager,
                                          location: CLLocation) { }

    func locationManagerDidUpdateHeading(_ locationManager: LocationManager,
                                         heading: CLHeading) { }
}

/// Handles retrieving the location and heading from CoreLocation
/// Does not contain anything related to ARKit or advanced location
public class LocationManager: NSObject {
    weak var delegate: LocationManagerDelegate?

    private var locationManager = CLLocationManager()

    var currentLocation: CLLocation?

    private(set) public var heading: CLHeading?
    private(set) public var headingAccuracy: CLLocationDirection?

    override init() {
        super.init()

        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest //kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.headingFilter = 0.5 //kCLHeadingFilterNone
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.delegate = self
        locationManager.startUpdatingHeading()
        locationManager.startUpdatingLocation()

        locationManager.requestWhenInUseAuthorization()

        currentLocation = locationManager.location
    }

    func requestAuthorization() {
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {

    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locations.forEach {
            delegate?.locationManagerDidUpdateLocation(self, location: $0)
        }

        currentLocation = manager.location
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        heading = newHeading
        headingAccuracy = newHeading.headingAccuracy

        if newHeading.headingAccuracy >= 0 {
            delegate?.locationManagerDidUpdateHeading(self, heading: newHeading)
        }
    }

    public func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        return true
    }
}
