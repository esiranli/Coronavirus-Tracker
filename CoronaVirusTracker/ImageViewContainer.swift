//
//  ImageViewContainer.swift
//  CoronaVirusTracker
//
//  Created by EMRE on 24.03.2020.
//  Copyright © 2020 EMRE. All rights reserved.
//

import SwiftUI
import Combine

class ImageLoader: ObservableObject {
    
    @Published
    var data = Data()
    
    init(imageURL: String) {
        guard let url = URL(string: imageURL) else { return }
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            guard let data = data else { return }
            
            DispatchQueue.main.async {
                self.data = data
            }
        }.resume()
    }
}

struct ImageViewContainer: View {
    
    @ObservedObject
    private var loader: ImageLoader
    
    init(imageURL: String) {
        loader = ImageLoader(imageURL: imageURL)
    }
    
    var body: some View {
        Image(uiImage: (loader.data.isEmpty) ? UIImage(imageLiteralResourceName: "unknown") : UIImage(data: loader.data)!)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 40, height: 40)
//            .clipShape(Circle())
//            .overlay(Circle().stroke(Color.white, lineWidth: 2))
            .shadow(radius: 10)
    }
}

struct ImageViewContainer_Previews: PreviewProvider {
    static var previews: some View {
        ImageViewContainer(imageURL: "https://raw.githubusercontent.com/NovelCOVID/API/master/assets/flags/cm.png")
    }
}
