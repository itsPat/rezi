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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(
            UINib(nibName: "BusinessTableViewCell", bundle: .main),
            forCellReuseIdentifier: BusinessTableViewCell.reuseIdentifier
        )
        fetchBusinesses()
    }
    
    func fetchBusinesses() {
        NetworkManager.shared.searchForBusiness(term: "massage", latitude: "45.450573273797474", longitude: "-73.64710990655271") { [weak self] (result) in
            switch result {
            case .success(let businesses):
                self?.businesses = businesses
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print("Did fail with error: \(error.localizedDescription)")
            }
        }
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BusinessTableViewCell.reuseIdentifier) as? BusinessTableViewCell else {
            return UITableViewCell(style: .default, reuseIdentifier: "")
        }
        let business = businesses[indexPath.item]
        cell.configure(with: business)
        return cell
    }

}

