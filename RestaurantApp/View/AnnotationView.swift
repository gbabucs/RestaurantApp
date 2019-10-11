//
//  AnnotationView.swift
//  RestaurantApp
//
//  Created by ThunderFlash on 11/10/2019.
//  Copyright © 2019 system. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class AnnotationView: MKPointAnnotation {
    
    init(venue: Venues?, coordinate: CLLocationCoordinate2D) {
        super.init()
        
        self.title = venue?.name
        self.subtitle = venue?.location?.city
        self.coordinate = coordinate
    }

}
