//
//  MapViewModel.swift
//  Bari
//
//  Created by 김민성 on 2022/12/21.
//

import SwiftUI
import MapKit

class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate  {
    enum CameraMode { case tracking, free }
    @Published var mapView = MKMapView()
    @Published var region: MKCoordinateRegion!
    @Published var place: [String:String] = [:]
    @Published var placeFullName: String = ""
    @Published var permissionDenied = false
    @Published var cameraMode: CameraMode = .tracking {
        willSet(newValue) {
            if cameraMode != newValue {
                switch newValue {
                case .tracking:
                    changeCameraTrackingMode()
                case .free:
                    changeCameraFreeMode()
                }
            }
        }
    }
    let locationManager = CLLocationManager()
    private var defaultLocation: CLLocation = CLLocation(latitude: 37.551425, longitude: 126.988)
    private var zoom: CLLocationDistance = 1000
    
    
    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 5
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
    }
    
    func cameraModeToggle() {
        if cameraMode == .free {
            cameraMode = .tracking
        }else {
            cameraMode = .free
        }
    }
    
    private func changeCameraTrackingMode() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        mapView.setRegion(region , animated: true)
    }
    
    private func changeCameraFreeMode() {
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    
    @objc func onPinchGesture(_ sender: UIPinchGestureRecognizer) {
        cameraMode = .free
    }
    @objc func onPanGesture(_ sender: UIPanGestureRecognizer) {
        cameraMode = .free
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
            self.region = MKCoordinateRegion(center: manager.location?.coordinate ?? defaultLocation.coordinate, latitudinalMeters: zoom, longitudinalMeters: zoom)
            
            self.mapView.setRegion(self.region, animated: true)
        case .denied:
            permissionDenied.toggle()
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted:
            break
            
        @unknown default:
            break
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        DispatchQueue.main.async {
            guard let currentLocation = locations.last else { return }
            self.region = MKCoordinateRegion(center: currentLocation.coordinate, latitudinalMeters: self.zoom, longitudinalMeters: self.zoom)
            currentLocation.placemark(completion: { placemark, error in
                guard let placemark = placemark else {
                    return
                }
                self.place["streetName"] = placemark.streetName ?? ""
                self.place["streetNumber"] = placemark.streetNumber ?? ""
                self.place["city"] = placemark.city ?? ""
                self.place["neighborhood"] = placemark.neighborhood ?? ""
                self.place["state"] = placemark.state ?? ""
                self.place["country"] = placemark.country ?? ""
                self.place["zipCode"] = placemark.zipCode ?? ""
                self.placeFullName = placemark.fullName
                
            })
            print("update")
        }
        
    }
        
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        print("pausedLocationUpdates")
        manager.stopUpdatingLocation()
    }
    
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        print("resumeLocationUpdates")
    }
}

