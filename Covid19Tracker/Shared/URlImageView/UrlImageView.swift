//
//  URLImageView.swift
//  Covid19Tracker (iOS)
//
//  Created by Maharjan Binish on 2020/07/17.
//

import SwiftUI

struct UrlImageView: View {
    @ObservedObject var urlImageModel: UrlImageModel
    
    init(urlString: String?) {
        urlImageModel = UrlImageModel(urlString: urlString)
    }
    
    var body: some View {
        ZStack {
            if let uiimage = urlImageModel.image {
                Image(uiImage: uiimage)
                    .resizable()
                    .onTapGesture {
                        // save uiimage as file
                    }
            } else {
                Image(systemName: "hourglass")
                    .frame(width: 150, height: 150)
                    .imageScale(.large)
                    .spinning()
            }
        }
        .clipShape(Rectangle())
        .frame(width: 150, height: 150)
        .overlay(Rectangle().stroke(Color.white,lineWidth:4).shadow(radius: 10))
        
    }
}

struct UrlImageView_Previews: PreviewProvider {
    static var previews: some View {
        UrlImageView(urlString: nil)
    }
}
