//
//  GCDBlackBox.swift
//  Virtual-Tourist
//
//   Created by Reem Alosaimi on 12/01/19.
//   Copyright © 2019 Reem Alosaimi. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}

