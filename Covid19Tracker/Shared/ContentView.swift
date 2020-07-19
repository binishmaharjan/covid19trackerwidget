//
//  ContentView.swift
//  Shared
//
//  Created by Maharjan Binish on 2020/07/10.
//

import SwiftUI

struct ContentView: View {
    
    @State var displayText: String = "Hello World"
    @State var searchImagesURLStrings: [String] = []
    
    var bgImage: UIImage? {
        let filePath = FileManager.sharedContainerURL()
            .appendingPathComponent(FileManager.bgFileName)
        do {
            let data = try Data(contentsOf: filePath)
            let uiimage = UIImage(data: data)
            return uiimage
        } catch {
            return nil
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Text(displayText)
                    .onOpenURL { url in
                        self.displayText = url.absoluteString
                    }
            }
            .navigationBarTitle(Text("Home"), displayMode: .inline)
            .navigationBarItems(trailing: createSetBackgroundImageButton())
        }
    }
    
    private func createSetBackgroundImageButton() -> some View {
        NavigationLink(destination: SearchImageView()) { Image(systemName: "gear")}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
