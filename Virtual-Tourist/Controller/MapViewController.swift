//
//  MapViewController.swift
//  Virtual-Tourist
//
//   Created by Reem Alosaimi on 12/01/19.
//   Copyright © 2019 Reem Alosaimi. All rights reserved.
//

import UIKit
import MapKit
import CoreData



class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var deleteLable: UILabel!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    var coreDataStack: CoreDataStack?
    var onEdit = false
    var locations = [Pin]()
    
    let latitudeS = "Latitude"
    let longitudeS = "Longitude"
    let deltaLatitude = "LatitudeDelta"
    let deltaLongitude = "LongitudeDelta"
    let FirstLaunch = "FirstLaunch"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        coreDataStack = delegate.stack
        mapView.delegate = self
        
        initMapSetting()
        loadLocations()
    }
    
    
    @IBAction func onEditAction(_ sender: Any) {
        
        if (editButton.title == "Edit") {
            deleteLable.isHidden = false
            editButton.title = "Done"
            onEdit = true
        }
        else {
            deleteLable.isHidden = true
            editButton.title = "Edit"
            onEdit = false
        }
    }
    
    @IBAction func onLongPressAction(_ sender: Any) {
        
        let longPress = sender as? UILongPressGestureRecognizer
        
        let pressPoint = longPress?.location(in: mapView)
        let pressCoordinate = mapView.convert(pressPoint!, toCoordinateFrom: mapView)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = pressCoordinate
        
        let annotations = mapView.annotations
        
        var isFound = false
        for annotationEntry in annotations {
            if (annotationEntry.coordinate.latitude == pressCoordinate.latitude && annotationEntry.coordinate.longitude == pressCoordinate.longitude) {
                isFound = true
                break
            }
        }
        
        if !isFound {
            
            
            self.mapView.addAnnotation(annotation)
            
            
            let location = Pin( lat: annotation.coordinate.latitude,long: annotation.coordinate.longitude, context: (coreDataStack?.context)!)
            locations.append(location)
            
            
            getPhotoFromFlickr(1, location)
        }
        
    }
    
    private func initMapSetting() {
        
        let defaults = UserDefaults.standard
        if UserDefaults.standard.bool(forKey: FirstLaunch) {
            let centerLatitude  = defaults.double(forKey: latitudeS)
            let centerLongitude = defaults.double(forKey: longitudeS)
            let latitudeDelta   = defaults.double(forKey: deltaLatitude)
            let longitudeDelta  = defaults.double(forKey: deltaLongitude)
            
            let centerCoordinate = CLLocationCoordinate2D(latitude: centerLatitude, longitude: centerLongitude)
            let spanCoordinate = MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
            let region = MKCoordinateRegion(center: centerCoordinate, span: spanCoordinate)
            
            performUIUpdatesOnMain {
                self.mapView.setRegion(region, animated: true)
            }
        } else {
            defaults.set(true, forKey: FirstLaunch)
        }
    }
    
    
    func getPhotoFromFlickr(_ pageNumber: Int, _ location: Pin) {
        
        Flickr.sharedInstance().searchPhotos(location.long,
                                             location.lat,
                                             pageNumber,
                                             completionHandlerSearchPhotos: { (result, pageNumberResult, error ) in
                                                
                                                if (error == nil) {
                                                    for urlString in result! {
                                                        self.coreDataStack?.context.perform {
                                                            let image = Photo(image: nil, imageURL: urlString, context: (self.coreDataStack?.context)!)
                                                            location.page = Int32(pageNumberResult!)
                                                            location.addToPhotos(image)
                                                        }
                                                        
                                                    }
                                                }
                                                else {
                                                    self.actionAlert(topic: "Fail to get photo from flickr", message: nil, complition: { (action) in
                                                        
                                                        self.dismiss(animated: true, completion: nil)
                                                    })
                                                    
                                                }
        })
    }
    
    
    func loadLocations() {
        let request: NSFetchRequest<Pin> = Pin.fetchRequest()
        if let result = try? coreDataStack?.context.fetch(request) {
            var annotationsArray = [MKPointAnnotation]()
            for location in result {
                let annotation = MKPointAnnotation()
                annotation.coordinate.latitude = location.lat
                annotation.coordinate.longitude = location.long
                annotationsArray.append(annotation)
                locations.append(location)
            }
            
            performUIUpdatesOnMain {
                self.mapView.addAnnotations(annotationsArray)
            }
        }
    }
    
    
    func getLocation(longitude: Double, latitude: Double) -> Pin? {
        var location: Pin?
        let request: NSFetchRequest<Pin> = Pin.fetchRequest()
        
        if let result = try? coreDataStack?.context.fetch(request) {
            for locationInResult in result {
                if (locationInResult.lat == latitude && locationInResult.long == longitude) {
                    location = locationInResult
                    break
                }
            }
        }
        return location
    }
    
}

