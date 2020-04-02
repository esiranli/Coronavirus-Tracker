//
//  ContentView.swift
//  CoronaVirusTracker
//
//  Created by EMRE on 22.03.2020.
//  Copyright © 2020 EMRE. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        TabView {
            WorldView().tabItem {
                Image(systemName: "globe")
                Text("World")
            }.tag(0)
//            .environmentObject(CountryStore())
            
            CountryList().tabItem {
                Image(systemName: "map")
                Text("Countries")
            }.environmentObject(CountryStore())
            .tag(1)
        }.font(.headline)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
