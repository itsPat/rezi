//
//  BusinessTableViewCell.swift
//  rezi
//
//  Created by Pat Trudel on 2020-03-28.
//  Copyright © 2020 Pat Trudel. All rights reserved.
//

import UIKit

class BusinessTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "BusinessTableViewCell"
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    private var business: Business? = nil
    
    func configure(with business: Business) {
        self.business = business
        callButton.isHidden = business.phone == nil
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
    
    @IBAction func didTapCall(_ sender: Any) {
        guard let url = URL(string: "tel://\(business?.phone ?? "")") else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func didTapCalendar(_ sender: Any) {
        print("Send them to detail booking page.")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mainImageView.image = nil
        titleLabel.text = nil
        subtitleLabel.text = nil
        ratingLabel.text = nil
    }
    
}
