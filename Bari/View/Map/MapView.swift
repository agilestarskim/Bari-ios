//
//  MapView.swift
//  Bari
//
//  Created by 김민성 on 2022/12/20.
//
import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    @Environment(\.mainWindowSize) var mainWindowSize
    @ObservedObject var vm: MapViewModel
    
    func makeCoordinator() -> Coordinator {
        return MapView.Coordinator(self)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        //mapView 설정
        let mapView = vm.mapView
        mapView.showsUserLocation = true
        mapView.showsCompass = false
        mapView.setUserTrackingMode(.follow, animated: true)
        
        //mapView 나침반 설정
        let compassBtn = MKCompassButton(mapView: mapView)
        compassBtn.frame.origin = CGPoint(x: mainWindowSize.width - 54 , y: 240 )
        compassBtn.frame.size = CGSize(width: 44, height: 44)
        compassBtn.compassVisibility = .adaptive
        mapView.addSubview(compassBtn)
        
        //mapView 재스처 설정: 확대 및 드래그
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: vm, action: #selector(vm.onPinchGesture(_:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: vm, action: #selector(vm.onPanGesture(_:)))
        mapView.addGestureRecognizer(pinchGestureRecognizer)
        mapView.addGestureRecognizer(panGestureRecognizer)
        pinchGestureRecognizer.delegate = context.coordinator
        panGestureRecognizer.delegate = context.coordinator
        
        mapView.delegate = context.coordinator
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
    }
    
    class Coordinator: NSObject, MKMapViewDelegate,UIGestureRecognizerDelegate {
        var parent: MapView
        init(_ parent: MapView) {
                self.parent = parent
            }
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKUserLocation {
                let pin = mapView.view(for:annotation) ?? MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
                let image = UIImage(named: "profile")?.circularImage(50)
                pin.image = image
                
                return pin

            } else {
                // handle other annotations
            }
            return nil
        }
        
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
                return true
        }
    }
}



