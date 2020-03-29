//
//  FeaturedTableViewCell.swift
//  rezi
//
//  Created by Pat Trudel on 2020-03-29.
//  Copyright © 2020 Pat Trudel. All rights reserved.
//

import UIKit

protocol FeaturedTableViewCellDelegate: class {
    func didSelect(business: Business)
}

class FeaturedTableViewCell: UITableViewCell {
    
    static let nib = UINib(nibName: "FeaturedTableViewCell", bundle: .main)
    static let reuseIdentifier = "FeaturedTableViewCell"

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private weak var delegate: FeaturedTableViewCellDelegate? = nil
    private var featuredSection: FeaturedSection? = nil {
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
        featuredSection = nil
        titleLabel.text = nil
        subtitleLabel.text = nil
    }
    
    func configure(with featuredSection: FeaturedSection, delegate: FeaturedTableViewCellDelegate) {
        self.featuredSection = featuredSection
        self.delegate = delegate
        titleLabel.text = featuredSection.title
        subtitleLabel.text = featuredSection.subtitle
        subtitleLabel.isHidden = featuredSection.subtitle == nil
    }
    
}

extension FeaturedTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return featuredSection?.businesses.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BusinessCollectionViewCell.reuseIdentifier, for: indexPath) as! BusinessCollectionViewCell
        let business = featuredSection?.businesses[indexPath.item]
        cell.configure(with: business)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let business = featuredSection?.businesses[indexPath.item] {
            delegate?.didSelect(business: business)
        }
    }
    
}


