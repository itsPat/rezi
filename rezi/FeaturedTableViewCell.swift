//
//  FeaturedTableViewCell.swift
//  rezi
//
//  Created by Pat Trudel on 2020-03-29.
//  Copyright © 2020 Pat Trudel. All rights reserved.
//

import UIKit

class FeaturedTableViewCell: UITableViewCell {
    
    static let nib = UINib(nibName: "FeaturedTableViewCell", bundle: .main)
    static let reuseIdentifier = "FeaturedTableViewCell"

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    private var businesses = [Business]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(BusinessCollectionViewCell.nib, forCellWithReuseIdentifier: BusinessCollectionViewCell.reuseIdentifier)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        businesses = []
        titleLabel.text = nil
        subtitleLabel.text = nil
    }
    
    func configure(with businesses: [Business], title: String, subtitle: String? = nil) {
        self.businesses = businesses
        titleLabel.text = title
        subtitleLabel.text = subtitle
        subtitleLabel.isHidden = subtitle == nil
    }
    
}

extension FeaturedTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return businesses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BusinessCollectionViewCell.reuseIdentifier, for: indexPath) as! BusinessCollectionViewCell
        let business = businesses[indexPath.item]
        cell.configure(with: business)
        return cell
    }
    
}

extension FeaturedTableViewCell: UICollectionViewDelegate {
    
}


