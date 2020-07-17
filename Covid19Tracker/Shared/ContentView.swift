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
    
    var body: some View {
        NavigationView {
            Text(displayText)
                .onOpenURL { url in
                    self.displayText = url.absoluteString
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
