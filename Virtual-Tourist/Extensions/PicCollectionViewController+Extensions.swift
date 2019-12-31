//
//  PicCollectionViewController+Extensions.swift
//  Virtual-Tourist
//
//  Created by Reem Alosaimi on 12/01/19.
//  Copyright © 2019 Reem Alosaimi. All rights reserved.
//

import CoreData
import UIKit
import MapKit



extension PicCollectionViewController: MKMapViewDelegate {
    
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
}
extension PicCollectionViewController: UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PicCollectionViewControllerCell", for: indexPath as IndexPath) as! PicCollectionViewControllerCell
        
        performUIUpdatesOnMain {
            cell.imageView.image = nil
            cell.activityIndicator.startAnimating()
        }
        
        let image = fetchedResultsController.object(at: indexPath)
        
        
        if let imageData = image.nsData {
            
            performUIUpdatesOnMain {
                cell.imageView.image = UIImage(data: imageData as Data)
                cell.activityIndicator.stopAnimating()
                
                if (self.downloadCounter > 0) {
                    self.downloadCounter = self.downloadCounter - 1
                }
                if self.downloadCounter == 0 {
                    self.collectionButton.isEnabled = true
                }
                
            }
        }
        else {
            
            self.downloadCounter = self.downloadCounter + 1
            let task = Flickr.sharedInstance().downloadImage(imageURL: image.imageURL!, completionHandler: { (imageData, error) in
                if (error == nil) {
                    
                    performUIUpdatesOnMain {
                        
                        cell.activityIndicator.stopAnimating()
                        if (self.downloadCounter > 0) {
                            self.collectionButton.isEnabled = false
                        }
                    }
                    
                    self.coreDataStack?.context.perform {
                        image.nsData = imageData as NSData?
                    }
                } else {
                    self.actionAlert(topic: "Download error", message: nil, complition: { (action) in
                        
                        self.dismiss(animated: true, completion: nil)
                    })
                }
            })
            cell.taskToCancelifCellIsReused = task
        }
        
        return cell
    }
}

extension PicCollectionViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        insertIndexes.removeAll()
        deleteIndexes.removeAll()
        updateIndexes.removeAll()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch (type) {
        case .insert:
            insertIndexes.append(newIndexPath!)
        case .delete:
            deleteIndexes.append(indexPath!)
        case .update:
            updateIndexes.append(indexPath!)
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView.performBatchUpdates( {
            self.collectionView.insertItems(at: insertIndexes)
            self.collectionView.deleteItems(at: deleteIndexes)
            self.collectionView.reloadItems(at: updateIndexes)
        }, completion: nil)
    }
}

extension PicCollectionViewController: UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let cell = collectionView.cellForItem(at: indexPath as IndexPath)
        if (!selectedIndexes.contains(indexPath)) {
            
            selectedIndexes.append(indexPath)
            
            cell?.alpha = 0.5
        } else {
            
            let index = selectedIndexes.firstIndex(of: indexPath)
            selectedIndexes.remove(at: index!)
            
            cell?.alpha = 1
        }
        
        
        if (selectedIndexes.count == 0) {
            collectionButton.setTitle("New Collection", for: .normal)
        } else {
            collectionButton.setTitle("Remove selected pictures", for: .normal)
        }
    }
}

