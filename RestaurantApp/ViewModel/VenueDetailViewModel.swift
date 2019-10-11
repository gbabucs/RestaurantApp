//
//  VenueDetailViewModel.swift
//  RestaurantApp
//
//  Created by ThunderFlash on 11/10/2019.
//  Copyright © 2019 system. All rights reserved.
//
import Foundation

class VenueDetailViewModel: NSObject {
    
    //--------------------------------------------------------------------------
    // MARK: - Properties
    //--------------------------------------------------------------------------
    
    var venue: Venues?
    
    var name: String? {
        return venue?.name
    }
    
    var fullAddress: String? {
        return venue?.location?.formattedAddress?.joined(separator: ", ")
    }
    
    //--------------------------------------------------------------------------
    // MARK: - Methods
    //--------------------------------------------------------------------------
    
    init(with venue: Venues) {
        self.venue = venue
    }
}
