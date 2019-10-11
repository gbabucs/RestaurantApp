//
//  VenueListViewModel.swift
//  RestaurantApp
//
//  Created by ThunderFlash on 11/10/2019.
//  Copyright © 2019 system. All rights reserved.
//
import Foundation

class VenueListViewModel: NSObject {
    
    //--------------------------------------------------------------------------
    // MARK: - Properties
    //--------------------------------------------------------------------------
    
    var venues : [Venues]?
    
    var isEmptyVenue: Bool {
        return (venues?.count ?? 0) == 0
    }
    
    //--------------------------------------------------------------------------
    // MARK: - Helpers
    //--------------------------------------------------------------------------
    
    func getRestaurant(with params: SearchParameter?, completion: @escaping(_ success: Bool) -> ()) {
        guard let query = params else { return }
        
        DataController().fetchVenues(with: query) { [weak self] venues, success in
            self?.venues = venues
            completion(success)
        }
    }
    
    func numberOfRowsInSection(section : Int) -> Int {
        return venues?.count ?? 0
    }
    
    func selectedObject(indexPath: IndexPath) -> Venues? {
        guard let venue = venues?[indexPath.row]
            else { return nil }
        
        return venue
    }
    
    func update(_ cell: VenueListCell, at indexPath: IndexPath) {
        guard let venue = venues?[indexPath.row]
            else { return }
        
        cell.configure(for: venue)
    }
}
