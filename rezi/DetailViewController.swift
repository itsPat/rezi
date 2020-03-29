//
//  DetailViewController.swift
//  rezi
//
//  Created by Pat Trudel on 2020-03-29.
//  Copyright © 2020 Pat Trudel. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class DetailViewController: UIViewController, BusinessTableViewCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    var business: Business!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        registerCells()
    }
        
// MARK: - Initial Setup
    
    func initialSetup() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        tableView.tableFooterView = UIView()
    }
    
    func registerCells() {
        tableView.register(BusinessDetailTableViewCell.nib, forCellReuseIdentifier: BusinessDetailTableViewCell.reuseIdentifier)
        tableView.register(BusinessDetailMapTableViewCell.nib, forCellReuseIdentifier: BusinessDetailMapTableViewCell.reuseIdentifier)
    }

// MARK: - Cell Factory
    
    func getBusinessDetailsCell() -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BusinessDetailTableViewCell.reuseIdentifier) as! BusinessDetailTableViewCell
        cell.configure(with: business, delegate: self)
        return cell
    }
    
    func getBusinessMapDetailsCell() -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BusinessDetailMapTableViewCell.reuseIdentifier) as! BusinessDetailMapTableViewCell
        cell.configure(with: business)
        return cell
    }

}

// MARK: - TableView Delegate // Data Source

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return indexPath.item == 0 ? getBusinessDetailsCell() : getBusinessMapDetailsCell()
    }
    
}

// MARK: - BusinessDetailTableViewCellDelegate

extension DetailViewController: BusinessDetailTableViewCellDelegate {
    
    func didTapFavorite() {
        //TODO: Handle networking for favoriting a business.
    }
    
    func didTapLocation() {
        guard let latitude = business.getLatitude(),
            let longitude = business.getLongitude() else { return }
        let regionDistance: CLLocationDistance = 500
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(
            center: coordinates,
            latitudinalMeters: regionDistance,
            longitudinalMeters: regionDistance
        )
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: region.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: region.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = business.getTitle()
        mapItem.openInMaps(launchOptions: options)
    }
    
    func didTapCall() {
        guard let phone = business.phone,
            phone.count > 1,
            let url = URL(string: "tel://\(business.phone ?? "")") else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
}
