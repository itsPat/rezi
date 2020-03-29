//
//  ViewController.swift
//  rezi
//
//  Created by Pat Trudel on 2020-03-28.
//  Copyright © 2020 Pat Trudel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var businesses = [Business]()
    var featuredSectionCount = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(BusinessTableViewCell.nib, forCellReuseIdentifier: BusinessTableViewCell.reuseIdentifier)
        tableView.register(FeaturedTableViewCell.nib, forCellReuseIdentifier: FeaturedTableViewCell.reuseIdentifier)
        fetchBusinesses()
    }
    
    func fetchBusinesses() {
        NetworkManager.shared.searchForBusiness(term: "massage", latitude: "45.450573273797474", longitude: "-73.64710990655271") { [weak self] (result) in
            switch result {
            case .success(let businesses):
                self?.businesses = businesses
                
                businesses.forEach { (b) in
                    print("\(b.getTitle()) has imageURL: \(b.imageURL)")
                }
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print("Did fail with error: \(error.localizedDescription)")
            }
        }
    }
    
    func getSingleBusinessCell(at index: Int) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BusinessTableViewCell.reuseIdentifier) as! BusinessTableViewCell
        let business = businesses[index]
        cell.configure(with: business, delegate: self)
        return cell
    }
    
    func getFeaturedCell(at section: Int) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FeaturedTableViewCell.reuseIdentifier) as! FeaturedTableViewCell
        let title = section == 0 ? "Featured" : "Your Favorites"
        let subtitle = section == 0 ? "Don't miss these deals" : "Places you ♥"
        let dropCount = section == 0 ? 10 : 20
        cell.configure(with: Array(businesses.dropFirst(dropCount)), title: title, subtitle: subtitle)
        return cell
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 + featuredSectionCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section < featuredSectionCount ? 1 : businesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if featuredSectionCount == 0 {
            // If there are no featured sections, return single business cells.
            return getSingleBusinessCell(at: indexPath.item)
        } else {
            // If there are featured sections, return featured sections first.
            switch indexPath.section {
            case 0..<featuredSectionCount:
                return getFeaturedCell(at: indexPath.section)
            default:
                return getSingleBusinessCell(at: indexPath.item)
            }
        }
    }

}

extension ViewController: BusinessTableViewCellDelegate {
    func didTapCalendar() {
        // Navigate to calendar booking page.
    }
}
