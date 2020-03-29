//
//  BusinessTableViewCell.swift
//  rezi
//
//  Created by Pat Trudel on 2020-03-28.
//  Copyright © 2020 Pat Trudel. All rights reserved.
//

import UIKit

protocol BusinessTableViewCellDelegate: class {
    func didTapFavorite()
}

class BusinessTableViewCell: UITableViewCell {
    
    static let nib = UINib(nibName: "BusinessTableViewCell", bundle: .main)
    static let reuseIdentifier = "BusinessTableViewCell"
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    private weak var delegate: BusinessTableViewCellDelegate? = nil
    private var business: Business? = nil
    
    func configure(with business: Business, delegate: BusinessTableViewCellDelegate) {
        self.delegate = delegate
        self.business = business
        business.getImage { [weak self] (result) in
            switch result {
            case .success(let image):
                if self?.business?.id == business.id {
                    self?.mainImageView.setImageWithAnimation(image: image)
                }
            case .failure(_):
                break // Place a default image.
            }
        }
        titleLabel.text = business.getTitle()
        subtitleLabel.text = business.getSubtitle()
        ratingLabel.text = business.getRating()
    }
    
    @IBAction func didTapFavorite(_ sender: Any) {
        delegate?.didTapFavorite()
        HapticManager.shared.fire(impactStyle: .light, notifStyle: nil, intensity: 1.0)
        favoriteButton.tintColor = favoriteButton.tintColor == .systemRed ? .systemGray : .systemRed
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        favoriteButton.tintColor = .systemGray
        mainImageView.image = nil
        titleLabel.text = nil
        subtitleLabel.text = nil
        ratingLabel.text = nil
    }
    
}
