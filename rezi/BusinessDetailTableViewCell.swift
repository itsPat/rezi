//
//  BusinessDetailTableViewCell.swift
//  rezi
//
//  Created by Pat Trudel on 2020-03-29.
//  Copyright © 2020 Pat Trudel. All rights reserved.
//

import UIKit

protocol BusinessDetailTableViewCellDelegate: class {
    func didTapFavorite()
    func didTapCall()
    func didTapLocation()
}

class BusinessDetailTableViewCell: UITableViewCell {
    
    static let nib = UINib(nibName: "BusinessDetailTableViewCell", bundle: .main)
    static let reuseIdentifier = "BusinessDetailTableViewCell"
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    private weak var delegate: BusinessDetailTableViewCellDelegate? = nil
    private var business: Business? = nil
    
    func configure(with business: Business, delegate: BusinessDetailTableViewCellDelegate) {
        self.delegate = delegate
        self.business = business
        business.getImage { [weak self] (result) in
            switch result {
            case .success(let image):
                if self?.business?.id == business.id {
                    DispatchQueue.main.async {
                        self?.mainImageView.image = image
                    }
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
        favoriteButton.tintColor = .systemGray
        mainImageView.image = nil
        titleLabel.text = nil
        subtitleLabel.text = nil
        ratingLabel.text = nil
    }
    
    @IBAction func didTapLocation(_ sender: Any) {
        delegate?.didTapLocation()
    }
    
    @IBAction func didTapCall(_ sender: Any) {
        delegate?.didTapCall()
    }
    
    @IBAction func didTapFavorite(_ sender: Any) {
        delegate?.didTapFavorite()
        HapticManager.shared.fire(impactStyle: .light, notifStyle: nil, intensity: 1.0)
        favoriteButton.tintColor = favoriteButton.tintColor == .systemRed ? .systemGray : .systemRed
    }
    
}
