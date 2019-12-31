//
//  CollectionViewController.swift
//  Virtual-Tourist
//
//   Created by Reem Alosaimi on 12/01/19.
//   Copyright © 2019 Reem Alosaimi. All rights reserved.
//


import CoreData
import UIKit
import MapKit

class PicCollectionViewController: UIViewController {
    
    @IBOutlet weak var collectionButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var selectedLocation: Pin!
    
    var coreDataStack: CoreDataStack?
    var totalPageNumber : Int = 1
    var currentPageNumber = 1
    var downloadCounter = 0
    
    var insertIndexes = [IndexPath]()
    var deleteIndexes = [IndexPath]()
    var updateIndexes = [IndexPath]()
    var selectedIndexes = [IndexPath]()
    
    
    lazy var fetchedResultsController: NSFetchedResultsController<Photo> = {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
        request.sortDescriptors = [NSSortDescriptor(key: "imageURL", ascending: true)]
        request.predicate = NSPredicate(format: "pin = %@", self.selectedLocation)
        
        let moc = coreDataStack?.context
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request as! NSFetchRequest<Photo>,
                                                                  managedObjectContext: moc!,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        return fetchedResultsController
    }()
    
    func performFetch() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        coreDataStack = delegate.stack
        
        mapView.delegate = self
        collectionView.delegate = self
        fetchedResultsController.delegate = self
        
        initLayout(size: view.frame.size)
        
        performFetch()
        
        initMap()
        
        initPhotos()
        
        self.collectionButton.isEnabled = false
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        initLayout(size: size)
    }
    
    
    @IBAction func performPictureAction(_ sender: Any) {
        if (collectionButton.titleLabel?.text == "New Collection") {
            
            collectionButton.isEnabled = false
            
            clearImages()
            
            if (currentPageNumber < totalPageNumber) {
                currentPageNumber = currentPageNumber + 1
            }
            else {
                currentPageNumber = totalPageNumber
            }
            
            self.collectionView.isHidden = false
            
            getPhotoFromFlickr(currentPageNumber)
            downloadImages()
            
        } else {
            deleteSelectedImage()
        }
    }
    func initLayout(size: CGSize) {
        let space: CGFloat = 3.0
        let dimension: CGFloat
        
        dimension = (size.width - (2 * space)) / 3.0
        
        flowLayout?.minimumInteritemSpacing = space
        flowLayout?.minimumLineSpacing = space
        flowLayout?.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    
    private func initMap() {
        
        let annotation = MKPointAnnotation()
        annotation.coordinate.latitude = selectedLocation.lat
        annotation.coordinate.longitude = selectedLocation.long
        
        let centerCoordinate = CLLocationCoordinate2D(latitude: selectedLocation.lat, longitude: selectedLocation.long)
        let spanCoordinate = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        let region = MKCoordinateRegion(center: centerCoordinate, span: spanCoordinate)
        
        performUIUpdatesOnMain {
            self.mapView.setRegion(region, animated: true)
            self.mapView.addAnnotation(annotation)
        }
    }
    
    
    private func initPhotos() {
        if (fetchedResultsController.fetchedObjects?.count == 0) {
            getPhotoFromFlickr(currentPageNumber)
        }
    }
    
    private func getPhotoFromFlickr(_ pageNumber: Int) {
        Flickr.sharedInstance().searchPhotos(selectedLocation.long,
                                             selectedLocation.lat,
                                             pageNumber,
                                             completionHandlerSearchPhotos: { (result, pageNumberResult, error ) in
                                                if (error == nil) {
                                                    
                                                    if (result?.count == 0) {
                                                        performUIUpdatesOnMain {
                                                            self.collectionView.isHidden = true
                                                        }
                                                    }
                                                    
                                                    self.coreDataStack?.context.perform {
                                                        for urlString in result! {
                                                            let image = Photo(image: nil, imageURL: urlString, context: (self.coreDataStack?.context)!)
                                                            self.selectedLocation.addToPhotos(image)
                                                        }
                                                    }
                                                    self.totalPageNumber = pageNumberResult!
                                                }
                                                else {
                                                    self.actionAlert(topic: "Fail to get images from Flickr", message: nil, complition: { (action) in
                                                        
                                                        self.dismiss(animated: true, completion: nil)
                                                    })
                                                }
        })
    }
    
    private func downloadImages() {
        coreDataStack?.performBackgroundBatchOperation { (workerContext) in
            for image in self.fetchedResultsController.fetchedObjects! {
                if image.nsData == nil {
                    _ = Flickr.sharedInstance().downloadImage(imageURL: image.imageURL!, completionHandler: { (imageData, error) in
                        
                        if (error == nil) {
                            image.nsData = imageData as NSData?
                        }
                        else {
                            self.actionAlert(topic: "***** Download error", message: nil, complition: { (action) in
                                self.dismiss(animated: true, completion: nil)})
                        }
                    })
                }
            }
        }
    }
    
    
    private func deleteSelectedImage() {
        
        for index in selectedIndexes {
            coreDataStack?.context.delete(fetchedResultsController.object(at: index))
        }
        
        selectedIndexes.removeAll()
        
        coreDataStack?.save()
        
        
        collectionButton.setTitle("New Collection", for: .normal)
    }
    
    
    private func clearImages() {
        
        for object in fetchedResultsController.fetchedObjects! {
            coreDataStack?.context.delete(object)
        }
        coreDataStack?.save()
    }
    
}


