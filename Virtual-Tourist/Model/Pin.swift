//
//  Pin.swift
//  Virtual-Tourist
//
//   Created by Reem Alosaimi on 12/01/19.
//   Copyright © 2019 Reem Alosaimi. All rights reserved.
//

import Foundation
import CoreData


public class Pin: NSManagedObject {
    
    convenience init(lat: Double, long: Double,  context: NSManagedObjectContext)
    {
        
        if let ent = NSEntityDescription.entity(forEntityName: "Pin", in: context)
        {
            self.init(entity: ent, insertInto: context)
            self.lat = lat
            self.long = long
            
        }
        else
        {
            fatalError("Unable to find Entity name!")
        }
    }
    
    
    
}

extension Pin {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pin> {
        return NSFetchRequest<Pin>(entityName: "Pin");
    }
    
    @NSManaged public var lat: Double
    @NSManaged public var long: Double
    @NSManaged public var page: Int32
    @NSManaged public var photos: NSSet?
    
}


extension Pin {
    
    @objc(addPhotosObject:)
    @NSManaged public func addToPhotos(_ value: Photo)
    
    @objc(removePhotosObject:)
    @NSManaged public func removeFromPhotos(_ value: Photo)
    
    @objc(addPhotos:)
    @NSManaged public func addToPhotos(_ values: NSSet)
    
    @objc(removePhotos:)
    @NSManaged public func removeFromPhotos(_ values: NSSet)
    
}



