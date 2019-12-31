//
//  PicCollectionViewControllerCell.swift
//  Virtual-Tourist
//
//   Created by Reem Alosaimi on 12/01/19.
//   Copyright © 2019 Reem Alosaimi. All rights reserved.
//

import UIKit
import Kingfisher

class PicCollectionViewControllerCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var taskToCancelifCellIsReused: URLSessionTask? {
        
        didSet {
            if let taskToCancel = oldValue {
                taskToCancel.cancel()
            }
            
        }
    }
}
