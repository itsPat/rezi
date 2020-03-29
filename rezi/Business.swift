//
//  Business.swift
//  rezi
//
//  Created by Pat Trudel on 2020-03-28.
//  Copyright © 2020 Pat Trudel. All rights reserved.
//

import UIKit

class Business: Decodable {
    var id: String? = nil
    var phone: String? = nil
    var imageURL: String? = nil
    var distance: Double? = nil
    private var rating: Double? = nil
    private var price: String? = nil
    private var isClosed: Bool? = nil
    private var categories: [[String:String]]? = nil
    private var name: String? = nil
    private var url: String? = nil
    private var coordinates: [String: Double]? = nil
    
    enum CodingKeys: String, CodingKey {
        case id, rating, price, phone, categories, name, url, coordinates, distance
        case isClosed = "is_closed"
        case imageURL = "image_url"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try? values.decode(String?.self, forKey: .id) ?? nil
        rating = try? values.decode(Double?.self, forKey: .rating) ?? nil
        price = try? values.decode(String?.self, forKey: .price) ?? nil
        phone = try? values.decode(String?.self, forKey: .phone) ?? nil
        isClosed = try? values.decode(Bool?.self, forKey: .isClosed) ?? nil
        categories = try? values.decode([[String:String]]?.self, forKey: .categories) ?? nil
        name = try? values.decode(String?.self, forKey: .name) ?? nil
        url = try? values.decode(String?.self, forKey: .url) ?? nil
        imageURL = try? values.decode(String?.self, forKey: .imageURL) ?? nil
        coordinates = try? values.decode([String: Double]?.self, forKey: .coordinates) ?? nil
        distance = try? values.decode(Double?.self, forKey: .distance) ?? nil
    }
    
    func getTitle() -> String {
        return name ?? ""
    }
    
    func getSubtitle() -> String {
        let distanceInKM = Int((distance ?? 0.0) / 1000.0)
        let keywords = [
            price ?? "$$",
            "\(distanceInKM) km"
        ]
        return keywords.joined(separator: " · ")
    }
    
    func getRating() -> String {
        guard let rating = rating else { return "" }
        var ratingInStars = ""
        for _ in 1...Int(rating) {
            ratingInStars += "★"
        }
        return ratingInStars
    }
    
    func getImage(completion: @escaping (Result<UIImage, Error>) -> ()) {
        ImageManager.shared.getImage(with: imageURL ?? "") { (result) in
            switch result {
            case .success(let image):
                completion(.success(image))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
