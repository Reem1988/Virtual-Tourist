//
//  Photo.swift
//  Virtual-Tourist
//
//   Created by Reem Alosaimi on 12/01/19.
//   Copyright © 2019 Reem Alosaimi. All rights reserved.
//

import Foundation
import CoreData


public class Photo: NSManagedObject {
    
    
    convenience init(image: NSData?, imageURL: String?, context: NSManagedObjectContext) {
        
        
        if let ent = NSEntityDescription.entity(forEntityName: "Photo", in: context) {
            self.init(entity: ent, insertInto: context)
            self.nsData = image
            self.imageURL = imageURL
        } else {
            fatalError("Unable to find Entity name!")
        }
    }
    
    
}
extension Photo {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo");
    }
    @NSManaged public var imageURL: String?
    @NSManaged public var nsData: NSData?
    @NSManaged public var pin: Pin?
    
}

