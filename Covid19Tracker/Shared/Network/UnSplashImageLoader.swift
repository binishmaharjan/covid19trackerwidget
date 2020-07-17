//
//  UnSplashImageFetcher.swift
//  Covid19Tracker (iOS)
//
//  Created by Maharjan Binish on 2020/07/17.
//

import Foundation

struct UnSplashedImageLoader {
    static func fetchImages(for query: String, completion: @escaping (Result<[SearchImage], Error>) -> Void) {
        var urlComponents = URLComponents(string: "https://api.unsplash.com/search/photos/")!
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: "1"),
            URLQueryItem(name: "query", value: query),
        ]
        
        let session = URLSession.shared
        var request = URLRequest(url: urlComponents.url!)
        request.setValue("Client-ID PKM7tRkOqPYCEp6PQqzUHXfGmf0d_7rGJkjC2LbmvEU",
                         forHTTPHeaderField: "Authorization")
        
        DispatchQueue.global().async {
            session.dataTask(with: request) { data, response, error in
                if let responseData = data {
                    do {
                        let items = try JSONDecoder().decode(SearchImages.self, from: responseData)
                        DispatchQueue.main.async { completion(.success(items.images)) }
                    } catch {
                        DispatchQueue.main.async { completion(.failure(error)) }
                    }
                }
            }.resume()
        }
    }
}
