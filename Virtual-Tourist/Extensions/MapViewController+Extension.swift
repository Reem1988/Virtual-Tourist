//
//  MapViewController+Extension.swift
//  Virtual-Tourist
//
//   Created by Reem Alosaimi on 12/01/19.
//   Copyright © 2019 Reem Alosaimi. All rights reserved.
//

import UIKit
import MapKit
import CoreData



extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = false
            pinView!.pinTintColor = .red
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    // Save the region everytime we change the map
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let defaults = UserDefaults.standard
        defaults.set(self.mapView.region.center.latitude, forKey: latitudeS)
        defaults.set(self.mapView.region.center.longitude, forKey: longitudeS)
        defaults.set(self.mapView.region.span.latitudeDelta, forKey: deltaLatitude)
        defaults.set(self.mapView.region.span.longitudeDelta, forKey: deltaLongitude)
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView){
        let coordinate = view.annotation?.coordinate
        if (onEdit) {
            
            for location in locations {
                if location.lat == (coordinate!.latitude) && location.long == (coordinate!.longitude) {
                    
                    let annotationToRemove = view.annotation
                    self.mapView.removeAnnotation(annotationToRemove!)
                    coreDataStack?.context.delete(location)
                    coreDataStack?.save()
                    
                    break
                }
            }
        } else {
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "PicCollectionViewController") as! PicCollectionViewController
            
            // Grab the location object from Core Data
            let location = self.getLocation(longitude: coordinate!.longitude, latitude: coordinate!.latitude)
            
            vc.selectedLocation = location
            vc.totalPageNumber = location?.value(forKey: "page") as! Int
            
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
}
