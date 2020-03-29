//
//  DetailViewController.swift
//  rezi
//
//  Created by Pat Trudel on 2020-03-29.
//  Copyright © 2020 Pat Trudel. All rights reserved.
//

import UIKit

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
    }

// MARK: - Cell Factory
    
    func getBusinessDetailsCell() -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BusinessDetailTableViewCell.reuseIdentifier) as! BusinessDetailTableViewCell
        cell.configure(with: business, delegate: self)
        return cell
    }

}

// MARK: - TableView Delegate // Data Source

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       return getBusinessDetailsCell()
    }
    
}

// MARK: - BusinessDetailTableViewCellDelegate

extension DetailViewController: BusinessDetailTableViewCellDelegate {
    
    func didTapFavorite() {
        //TODO: Handle networking for favoriting a business.
    }
    
    func didTapCalendar() {
        //TODO: Show Booking View Controller.
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
