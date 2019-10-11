//
//  DataController.swift
//  RestaurantApp
//
//  Created by ThunderFlash on 11/10/2019.
//  Copyright © 2019 system. All rights reserved.
//

import Foundation
import UIKit

class DataController: NSObject {
    
    //--------------------------------------------------------------------------
    // MARK: - Fetch Venue
    //--------------------------------------------------------------------------
    
    func fetchVenues(with query: SearchParameter, completion: @escaping([Venues]?, _ success: Bool) -> Void) {
        var venues: [Venues]?
        
        DataAdapter.shared.fetchPlaces(query: query) { isSuccess, places in
            
            if isSuccess {
                venues = places?.response?.venues
            }
            
            completion(self.sortedByDistance(venues: venues ?? []), isSuccess)
        }
    }
    
    //--------------------------------------------------------------------------
    // MARK: - Helpers
    //--------------------------------------------------------------------------
    
    func sortedByDistance(venues: [Venues]) -> [Venues] {
        return venues.sorted(by: { $0.location?.distance ?? 0 < $1.location?.distance ?? 0 })
    }
}
