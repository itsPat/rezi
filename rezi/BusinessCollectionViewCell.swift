//
//  BusinessCollectionViewCell.swift
//  rezi
//
//  Created by Pat Trudel on 2020-03-29.
//  Copyright © 2020 Pat Trudel. All rights reserved.
//

import UIKit

class BusinessCollectionViewCell: UICollectionViewCell {
    
    static let nib = UINib(nibName: "BusinessCollectionViewCell", bundle: .main)
    static let reuseIdentifier = "BusinessCollectionViewCell"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    private var business: Business? = nil
    
    func configure(with business: Business?) {
        guard let business = business else { return }
        self.business = business
        business.getImage { [weak self] (result) in
            switch result {
            case .success(let image):
                if self?.business?.id == business.id {
                    self?.imageView.setImageWithAnimation(image: image)
                }
            case .failure(_):
                break // Place a default image.
            }
        }
        titleLabel.text = business.getTitle()
        subtitleLabel.text = business.getSubtitle()
        ratingLabel.text = business.getRating()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        titleLabel.text = nil
        subtitleLabel.text = nil
        ratingLabel.text = nil
    }

}
