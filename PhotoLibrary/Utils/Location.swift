//
//  Location.swift
//  PhotoLibrary
//
//  Created by Dodi Aditya on 07/11/23.
//

import Foundation
import CoreLocation

class LocationFetcher: NSObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    var lastKnownLocation: CLLocationCoordinate2D?
    
    var completion: ((CLLocation) -> Void)?
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func start() {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func requestLocation(callback: @escaping (CLLocation) -> Void) {
        self.completion = callback
        start()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            lastKnownLocation = location.coordinate
            completion?(location)
        }
    }
}
