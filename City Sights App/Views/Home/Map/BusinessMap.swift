//
//  BusinessMap.swift
//  City Sights App
//
//  Created by Michael Baumgarten on 10/11/21.
//

import SwiftUI
import MapKit

struct BusinessMap: UIViewRepresentable {

    @EnvironmentObject var model: ContentModel
    @Binding var selectedBusiness: Business?

    var locations:[MKPointAnnotation] {
        // Create a set of annotations from our list of businesses
        var annotations = [MKPointAnnotation]()
        
        for business in model.restaurants + model.sights {
            // create a new annotation
            
            if let lat = business.coordinates?.latitude, let long = business.coordinates?.longitude {
                let a = MKPointAnnotation()
                a.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                a.title = business.name
                annotations.append(a)
            }
            
        }
        return annotations
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        
        // Make the user show up on the map
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .followWithHeading
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        // Remove all annotations
        uiView.removeAnnotations(uiView.annotations)

        // Add the ones based on the business
        uiView.showAnnotations(self.locations, animated: true)
        
    }
    
    static func dismantleUIView(_ uiView: MKMapView, coordinator: ()) {
        uiView.removeAnnotations(uiView.annotations)
    }
    
    // MARK - Coordinator class
    func makeCoordinator() -> Coordinator {
        return Coordinator(map: self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var map: BusinessMap
        init(map:BusinessMap) {
            self.map = map
        }
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
            // if the annotation is the user blue dot, return nil
            if annotation is MKUserLocation {
                return nil
            }
            
            // check if there's a resuable annotation view first
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: Constants.annotationReuseId)
            
            if annotationView == nil {
                // Create an annotation view
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: Constants.annotationReuseId)
                annotationView!.canShowCallout = true
                annotationView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            } else {
                // we got a reusable one
                annotationView!.annotation = annotation
            }
            

            // Return it
            return annotationView
        }
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            // User tapped on the annotation view
            
            // Get the business object that this annotation represents
            
            // Loop through businesses in the model to find match
            for business in map.model.restaurants + map.model.sights {
                if business.name == view.annotation?.title{
                    // set the selectedBusiness
                    map.selectedBusiness = business
                    return
                }
            }
        }
    }
}
