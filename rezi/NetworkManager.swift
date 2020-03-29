//
//  NetworkManager.swift
//  rezi
//
//  Created by Pat Trudel on 2020-03-28.
//  Copyright © 2020 Pat Trudel. All rights reserved.
//

import UIKit

let YELP_API_KEY = "Bearer gM_n2TEHQWYQaDk-urKzj5klKc2sT74XP0FKmW_SHZTVCqB41hOmaZz6RUt3aQTdx0DnGOPmn-TMdyDJnBPl2tT3Tf4tx9H8PnTRc8Vxz1mNuCRKZGUcD878cOLeXHYx"

struct YelpSearchResponse: Decodable {
    let total: Int?
    let businesses: [Business]?
    let region: [String: [String: Double]]?
}

class NetworkManager: NSObject {

    static let shared = NetworkManager()
    
    func searchForBusiness(term: String,
                           latitude: String,
                           longitude: String,
                           limit: Int? = 50,
                           offset: Int? = 0,
                           openNow: Bool? = false,
                           completion: @escaping (Result<[Business], Error>) -> ()) {
        
        var components = URLComponents(string: "https://api.yelp.com/v3/businesses/search")
        
        components?.queryItems = [
            URLQueryItem(name: "term", value: term),
            URLQueryItem(name: "latitude", value: latitude),
            URLQueryItem(name: "longitude", value: longitude),
            URLQueryItem(name: "limit", value: "\(limit ?? 50)"),
            URLQueryItem(name: "offset", value: "\(offset ?? 0)"),
            URLQueryItem(name: "open_now", value: openNow ?? false ? "true" : "false"),
        ]
        
        guard let url = components?.url else { return }
        var request = URLRequest(url: url)
        request.setValue(YELP_API_KEY, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, _, err) in
            if let err = err {
                completion(.failure(err))
            }
            guard let data = data else { return }
            do {
                let searchResponse = try JSONDecoder().decode(YelpSearchResponse.self, from: data)
                let businessesWithImages = (searchResponse.businesses ?? [])
                    .filter({$0.imageURL != nil}) // Only get businesses with imageURLs
                    .sorted(by: {$0.distance ?? 0.0 < $1.distance ?? 0.0}) // Sort by distance.
                completion(.success(businessesWithImages))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getImage(with url: String, completion: @escaping (Result<UIImage, Error>) -> ()) {
        // Do not call this method directly, use ImageManager.shared.getImage()
        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            if let error = err {
                completion(.failure(error))
            } else if let data = data,
                let image = UIImage(data: data) {
                completion(.success(image))
            }
        }.resume()
    }
    
}
