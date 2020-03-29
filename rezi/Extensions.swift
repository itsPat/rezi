//
//  Extensions.swift
//  rezi
//
//  Created by Pat Trudel on 2020-03-29.
//  Copyright © 2020 Pat Trudel. All rights reserved.
//

import UIKit

extension UIImageView {
    func setImageWithAnimation(image: UIImage) {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            UIView.transition(with: self,
            duration: 0.5,
            options: .transitionCrossDissolve,
            animations: { self.image = image },
            completion: nil)
        }
    }
}
