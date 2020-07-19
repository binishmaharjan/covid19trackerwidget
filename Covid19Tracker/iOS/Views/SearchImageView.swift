//
//  SearchImageView.swift
//  Covid19Tracker (iOS)
//
//  Created by Maharjan Binish on 2020/07/17.
//

import SwiftUI

struct SearchImageView: View {
    
    @State private var searchText: String = ""
    @State private var searchImages: [SearchImage] = []
    
    private let layout = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack {
            ScrollView {
                SearchBar(text: $searchText, returnHandler: { self.fetchImages() })
                    .padding(.vertical, 10)
                
                LazyVGrid(columns: layout, spacing: 20) {
                    ForEach(self.searchImages, id: \.id) { (item)  in
                        UrlImageView(urlString: item.urls.regular)
                    }
                }
                
                Spacer()
            }
        }
    }
    
    private func fetchImages() {
        UnSplashedImageLoader.fetchImages(for: searchText) { (result) in
            switch result {
            case .success(let items):
                self.searchImages = items
            case .failure(let error):
                print("---- Error: Could Not Decode JSON -----")
                print(error.localizedDescription)
            }
        }
    }
}
