//
//  WorldView.swift
//  CoronaVirusTracker
//
//  Created by EMRE on 2.04.2020.
//  Copyright © 2020 EMRE. All rights reserved.
//

import SwiftUI

struct WorldView: View {
    
    @ObservedObject var viewModel: WorldViewModel = WorldViewModel()
    
    var body: some View {
        VStack(spacing: 24) {
            if viewModel.worldData != nil {
                VStack {
                    Text("Cases")
                        .font(.largeTitle)
                    Text("\(viewModel.worldData!.cases)")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                    
                }
                VStack {
                    Text("Deaths")
                        .font(.largeTitle)
                    Text("\(viewModel.worldData!.deaths)")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                    
                }
                VStack {
                    Text("Recovered")
                        .font(.largeTitle)
                    Text("\(viewModel.worldData!.recovered)")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                    
                }
                HStack {
                    Text("Last Updated Time:")
                        .font(.caption)
                    Text("\(displayDateFormatter.string(from: viewModel.worldData!.updated))")
                        .font(.caption)
                }
            }
        }
    }
}

struct WorldView_Previews: PreviewProvider {
    static var previews: some View {
        WorldView()
    }
}

class WorldViewModel: ObservableObject {
    
    @Published var worldData: WorldData!
    
    init() {
        loadWorldData()
    }
    
    func loadWorldData() {
        let urlString = "https://corona.lmao.ninja/all"
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            guard let data = data else { return }
                
            do {
                let decoder = JSONDecoder()
            //                decoder.dateDecodingStrategy = .formatted(dateFormatter)
                let worldData = try decoder.decode(WorldData.self, from: data)
                DispatchQueue.main.async {
                    self.worldData = worldData
                }
            } catch {
                print("Decoding error", error)
            }
        }.resume()
    }
    
}
