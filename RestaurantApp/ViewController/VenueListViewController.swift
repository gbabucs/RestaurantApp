//
//  VenueListViewController.swift
//  RestaurantApp
//
//  Created by ThunderFlash on 11/10/2019.
//  Copyright © 2019 system. All rights reserved.
//
import UIKit
import Reachability
import JGProgressHUD
import MapKit

class VenueListViewController: UIViewController {
    
    //--------------------------------------------------------------------------
    // MARK: - IBOutlet
    //--------------------------------------------------------------------------
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    
    //--------------------------------------------------------------------------
    // MARK: - properties
    //--------------------------------------------------------------------------
    
    let reachability : Reachability! = Reachability()
    let hud = JGProgressHUD(style: .dark)
    
    var queryParams = SearchParameter()
    var viewModel = VenueListViewModel()
    
    fileprivate var coordinate: Coordinate?
    var locationManager: CLLocationManager!
    var onLocationUpdate: ((Coordinate) -> ())?
    
    private(set) var selectedVenue: Venues?
    private var isReachable: Bool {
        guard reachability.connection != .none else { return false }
        
        return true
    }
    
    //--------------------------------------------------------------------------
    // MARK: - LifeCyle
    //--------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Restaurant List"
        
        self.startWatchingReachability()
        
        mapView.delegate = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 115
        tableView.tableFooterView = UIView()
        
        self.onLocationUpdate = { coordinate in
            self.queryParams.coordinate = coordinate
            self.fetchData()
        }
        
        self.mapView.mapType = .standard
        self.mapView.showsUserLocation = true
        self.mapView.showAnnotations(mapView.annotations, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        determineCurrentLocation()
    }
    
    //--------------------------------------------------------------------------
    // MARK: - Private functions
    //--------------------------------------------------------------------------
    
    @objc
    private func fetchData() {
        if isReachable {
            hud.show(in: self.view)
            viewModel.getRestaurant(with: queryParams) { success in
                DispatchQueue.main.async {
                    if success, self.viewModel.isEmptyVenue == false {
                        self.tableView.reloadData()
                        self.addAnnotations()
                    } else {
                        self.showErrorAlert(fot: "Error", message: "Please try again later")
                    }
                    
                    self.hud.dismiss()
                }
            }
        } else {
            self.showErrorAlert(fot: "No Internet Connection", message: "Please try again later")
        }
    }
    
    //--------------------------------------------------------------------------
    // MARK: - Helper functions
    //--------------------------------------------------------------------------
    
    func startWatchingReachability() {
        try? self.reachability.startNotifier()
    }
    
    //--------------------------------------------------------------------------
    // MARK: - Helpers
    //--------------------------------------------------------------------------
    
    func determineCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    //--------------------------------------------------------------------------
    // MARK: - Navigation
    //--------------------------------------------------------------------------
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showVenueDetailViewController",
            let venueDetailViewController = segue.destination as? VenueDetailViewController,
            let indexPath = sender as? IndexPath,
            let venue  = viewModel.selectedObject(indexPath: indexPath)
            else { return }
        
        venueDetailViewController.venue = venue
        
        guard let selectedCell = tableView.indexPathForSelectedRow else { return }
        
        tableView.deselectRow(at: selectedCell, animated: false)
    }
    
}


//--------------------------------------------------------------------------
// MARK: - UITableViewDelegate
//--------------------------------------------------------------------------


extension VenueListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showVenueDetailViewController", sender: indexPath)
    }
}

//--------------------------------------------------------------------------
// MARK: - UITableViewDataSource
//--------------------------------------------------------------------------

extension VenueListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VenueListCell.reuseIdentifier, for: indexPath) as? VenueListCell
            else { return UITableViewCell() }
        
        viewModel.update(cell, at: indexPath)
        
        return cell
    }
}

//--------------------------------------------------------------------------
// MARK: - CLLocationManagerDelegate
//--------------------------------------------------------------------------

extension VenueListViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let coordinate = Coordinate(location: location)
        //let customLocation = CLLocation(latitude: 37.785834, longitude: -122.406417)
        // let customCoordinate = Coordinate(location: customLocation)
        
        if queryParams.coordinate != coordinate {
            if let onLocationUpdate = onLocationUpdate {
                onLocationUpdate(coordinate)
            }
        }
    }
}

// MARK: - MKMapViewDelegate

extension VenueListViewController: MKMapViewDelegate {
    
    // MARK: - Map View
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        var region = MKCoordinateRegion()
        
        region.center = mapView.userLocation.coordinate
        region.span.latitudeDelta = 0.01
        region.span.longitudeDelta = 0.01
        
        mapView.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }
    
    
    func addAnnotations() {
        removeAnnotations()
        
        guard let venues = viewModel.venues,
            venues.count > 0
            else { return }
        
        let annotationViews: [MKPointAnnotation] = venues.map { venue in
            var point = MKPointAnnotation()
            
            guard let coordinate = venue.location?.coordinate else { return point }
            
            let coordinate2D = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
            point = AnnotationView(venue: venue, coordinate: coordinate2D)
            
            return point
        }
        
        mapView.addAnnotations(annotationViews)
    }
    
    func removeAnnotations() {
        let annotations = mapView.annotations
        
        annotations.forEach { annotation in
            mapView.removeAnnotation(annotation)
        }
    }
}
