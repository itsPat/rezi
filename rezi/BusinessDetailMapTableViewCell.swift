//
//  BusinessDetailMapTableViewCell.swift
//  rezi
//
//  Created by Pat Trudel on 2020-03-29.
//  Copyright © 2020 Pat Trudel. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class BusinessDetailMapTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mapView: MKMapView!
    
    static let nib = UINib(nibName: "BusinessDetailMapTableViewCell", bundle: .main)
    static let reuseIdentifier = "BusinessDetailMapTableViewCell"
    
    func configure(with business: Business) {
        guard let latitude = business.getLatitude(),
            let longitude = business.getLongitude() else { return }
        let regionDistance:CLLocationDistance = 500
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(
            center: coordinates,
            latitudinalMeters: regionDistance,
            longitudinalMeters: regionDistance
        )
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        annotation.title = business.getTitle()
        
        mapView.addAnnotation(annotation)
        mapView.setRegion(region, animated: true)
    }
    
}
