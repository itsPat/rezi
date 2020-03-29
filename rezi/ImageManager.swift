//
//  ImageManager.swift
//  rezi
//
//  Created by Pat Trudel on 2020-03-28.
//  Copyright © 2020 Pat Trudel. All rights reserved.
//

import UIKit

class ImageManager: NSObject {

    static let shared = ImageManager()
    private var imageCache = NSCache<NSString, UIImage>()
    
    func getImage(with url: String, completion: @escaping (Result<UIImage, Error>) -> ()) {
        if let localImage = imageCache.object(forKey: url as NSString) {
            completion(.success(localImage))
        } else {
            NetworkManager.shared.getImage(with: url) { [weak self] (result) in
                switch result {
                case .success(let image):
                    self?.imageCache.setObject(image, forKey: url as NSString)
                    completion(.success(image))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
}
