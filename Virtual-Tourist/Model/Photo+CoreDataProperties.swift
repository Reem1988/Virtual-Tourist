//
//  Photo+CoreDataProperties.swift
//  Virtual-Tourist
//
//   Created by Reem Alosaimi on 12/01/19.
//   Copyright © 2019 Reem Alosaimi. All rights reserved.
//

import Foundation
import CoreData


extension Photo {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo");
    }
    @NSManaged public var imageURL: String?
    @NSManaged public var nsData: NSData?
    @NSManaged public var pin: Pin?
    
}

