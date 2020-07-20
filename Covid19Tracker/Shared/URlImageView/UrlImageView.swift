//
//  URLImageView.swift
//  Covid19Tracker (iOS)
//
//  Created by Maharjan Binish on 2020/07/17.
//

import SwiftUI
import WidgetKit

struct UrlImageView: View {
    @ObservedObject var urlImageModel: UrlImageModel
    @State var showAlert: Bool = false
    
    let sharedContainerURL: URL = FileManager.default.containerURL(
        forSecurityApplicationGroupIdentifier: "group.com.binish.Covid19Tracker"
    )!
    
    init(urlString: String?) {
        urlImageModel = UrlImageModel(urlString: urlString)
    }
    
    var body: some View {
        ZStack {
            if let uiimage = urlImageModel.image {
                Image(uiImage: uiimage)
                    .resizable()
                    .onTapGesture {
                        if let data = uiimage.pngData() {
                            let filename = sharedContainerURL.appendingPathComponent("bg.png")
                            try? data.write(to: filename)
                            self.showAlert = true
                            WidgetCenter.shared.reloadAllTimelines()
                        }
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
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Saved"), message: Text("Image Saved"), dismissButton: .default(Text("Ok")))
        }
        
    }
}

struct UrlImageView_Previews: PreviewProvider {
    static var previews: some View {
        UrlImageView(urlString: nil)
    }
}
