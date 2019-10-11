//
//  VenueDetailViewController.swift
//  RestaurantApp
//
//  Created by ThunderFlash on 11/10/2019.
//  Copyright © 2019 system. All rights reserved.
//
import UIKit

class VenueDetailViewController: UIViewController {
    
    //--------------------------------------------------------------------------
    // MARK: - IBOutlet
    //--------------------------------------------------------------------------
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!
    
    //--------------------------------------------------------------------------
    // MARK: - Properties
    //--------------------------------------------------------------------------
    
    var venue: Venues?
    
    //--------------------------------------------------------------------------
    // MARK: - LifeCyle
    //--------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let title = venue?.name ?? "Restaurant Details"
        
        self.title = "\(title)"
        
        self.setupView()
    }
    
    //--------------------------------------------------------------------------
    // MARK: - Helpers
    //--------------------------------------------------------------------------
    
    func setupView() {
        guard let venue = self.venue else { return }
        
        let viewModel = VenueDetailViewModel(with: venue)
        
        name.text = viewModel.name
        address.text = viewModel.fullAddress
    }
    
}

