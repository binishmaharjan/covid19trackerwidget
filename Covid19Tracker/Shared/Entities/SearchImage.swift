//
//  SearchImage.swift
//  Covid19Tracker (iOS)
//
//  Created by Maharjan Binish on 2020/07/17.
//

import Foundation

struct SearchImages: Codable {
    let images: [SearchImage]
    
    enum CodingKeys: String, CodingKey {
        case images = "results"
    }
}

struct SearchImage: Codable {
    var id = UUID()
    var urls: ImageURL
    
    enum CodingKeys: String, CodingKey {
           case urls
       }
}

struct ImageURL: Codable {
    var regular: String
}
