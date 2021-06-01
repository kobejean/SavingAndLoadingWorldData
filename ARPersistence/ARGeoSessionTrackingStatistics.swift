//
//  ARGeoSessionTrackingStatistics.swift
//  ARPersistence
//
//  Created by Jean Flaherty on 5/30/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation
import ARKit
import CoreLocation

class ARGeoSessionTrackingStatistics: NSObject {
    internal var locationAnchorLocation: CLLocation?
    internal var locationAnchorPosition: simd_float3?
    internal var aggregatedLocationsCount = 0
    internal var queuedlocations = Queue<CLLocation>()
    
    internal var headingTransform: simd_float2?
    internal var aggregatedHeadingsCount = 0
    internal var queuedHeadings = Queue<CLHeading>()
    
    var recordedFrames = [ARRecordedGeoFrame]()
    internal weak var delegate: ARGeoSessionTrackingStatisticsDelegate?
    
    func reset() {
        locationAnchorLocation = nil
        locationAnchorPosition = nil
        aggregatedLocationsCount = 0
        queuedlocations = Queue()
        
        headingTransform = nil
        aggregatedHeadingsCount = 0
        queuedHeadings = Queue()
        
        recordedFrames = [ARRecordedGeoFrame]()
    }
    
    
    // MARK: Aggregation
    
    func aggregateTrackingStatistics(recordedFrame: ARRecordedGeoFrame) {
        recordedFrames.append(recordedFrame)
        guard recordedFrames.count > 1 else { return }
        
        
        while let location = queuedlocations.front,
              let locationTimestamp = queuedlocations.front?.timestamp.timeIntervalSinceBootup(),
              let previousFrameIndex = recordedFrames.lastIndex(where: { $0.timestamp < locationTimestamp }),
              previousFrameIndex + 1 < recordedFrames.count {
            // dequeue
            queuedlocations.dequeue()
            
            aggregatedLocationsCount += 1
            
            aggregateLocationAnchorPosition(location: location, previousFrameIndex: previousFrameIndex)
            aggregateLocationAnchorLocation(location: location)
        }
        
        while let heading = queuedHeadings.front,
              heading.timestamp.timeIntervalSinceBootup() <= recordedFrame.timestamp {
            // dequeue
            queuedHeadings.dequeue()
            
            aggregatedHeadingsCount += 1
            
//            aggregateHeadingTransform(heading: heading, recordedFrame: recordedFrame,
//                                            lastRecordedFrame: lastRecordedFrame)
        }
    }
    
    // MARK: Aggregation - Location Aggregation
    
    func aggregateLocationAnchorPosition(location: CLLocation, previousFrameIndex: Int) {
        let nextFrameIndex = previousFrameIndex + 1
        let previousFrame = recordedFrames[previousFrameIndex]
        let nextFrame = recordedFrames[nextFrameIndex]
        guard let currentLocationAnchorPosition = locationAnchorPosition else {
            locationAnchorPosition = [0,0,0]
            return
        }
        
        
        let locationTimestamp = location.timestamp.timeIntervalSinceBootup()
        let alpha = Float((locationTimestamp - previousFrame.timestamp) / (nextFrame.timestamp - previousFrame.timestamp))
        let locationTransform = (1.0 - alpha) * previousFrame.transform + alpha * nextFrame.transform
        // ignore y-axis because coordinates are 2d
        let locationPosition: simd_float3 = [locationTransform.columns.3.x, 0, locationTransform.columns.3.z]
        let denominator = Float(aggregatedLocationsCount)
        let positionDelta = (locationPosition - currentLocationAnchorPosition) / denominator

        locationAnchorPosition = currentLocationAnchorPosition + positionDelta
        
        let locationFrameIndex = alpha < 0.5 ? previousFrameIndex : nextFrameIndex
        recordedFrames[locationFrameIndex].location = location
        
        delegate?.locationAdded(location: location, to: recordedFrames[locationFrameIndex])
    }
    
    func aggregateLocationAnchorLocation(location: CLLocation) {
        guard let previousLocationAnchorLocation = locationAnchorLocation else {
            locationAnchorLocation = location
            return
        }
        
        let denominator = Double(aggregatedLocationsCount)
        let lattitudeDelta = (location.coordinate.latitude - previousLocationAnchorLocation.coordinate.latitude) / denominator
        let longitudeDelta = (location.coordinate.longitude - previousLocationAnchorLocation.coordinate.longitude) / denominator
        
        locationAnchorLocation = CLLocation(
            latitude: previousLocationAnchorLocation.coordinate.latitude + lattitudeDelta,
            longitude: previousLocationAnchorLocation.coordinate.longitude + longitudeDelta
        )
    }
    
    // MARK: Aggregation - Heading Aggregation
    
    func aggregateHeadingTransform(heading: CLHeading, recordedFrame: ARRecordedGeoFrame, lastRecordedFrame: ARRecordedGeoFrame) {
        guard let previousHeadingTransform = headingTransform else {
            headingTransform = recordedFrame.transform.transformToHeading()
            return
        }
        
        let timestamp = heading.timestamp.timeIntervalSinceBootup()
        let alpha = Float((timestamp - lastRecordedFrame.timestamp) / (recordedFrame.timestamp - lastRecordedFrame.timestamp))
        let lastFrameHeading = lastRecordedFrame.transform.transformToHeading()
        let frameHeading = recordedFrame.transform.transformToHeading()
        let newHeading = (1.0 - alpha) * lastFrameHeading + alpha * frameHeading
        let multiplier = 1.0 / Float(aggregatedHeadingsCount)
        let headingTransformDelta = (newHeading - previousHeadingTransform) * multiplier
        
        headingTransform = previousHeadingTransform + headingTransformDelta
    }
}

protocol ARGeoSessionTrackingStatisticsDelegate: AnyObject {
    func locationAdded(location: CLLocation, to recordedGeoFrame: ARRecordedGeoFrame)
}

extension ARGeoSessionTrackingStatisticsDelegate {
    func locationAdded(location: CLLocation, to recordedGeoFrame: ARRecordedGeoFrame) { }
}
