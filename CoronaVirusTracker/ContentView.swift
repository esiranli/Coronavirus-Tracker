//
//  ContentView.swift
//  CoronaVirusTracker
//
//  Created by EMRE on 22.03.2020.
//  Copyright © 2020 EMRE. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject
    private var countryStore: CountryStore
    
    @State private var isShowing = false
    
    var body: some View {
        NavigationView {
            List(countryStore.filteredCountries) { country in
                NavigationLink(destination: CountryDetail(country: country)) {
                    CountryRow(data: country) { () -> ImageViewContainer in
                        ImageViewContainer(imageURL: country.countryInfo.flag)
                    }
                }
            }.background(PullToRefresh(action: {
                    self.countryStore.load(completion: { completed in self.isShowing = false })
                }, isShowing: $isShowing))
                .navigationBarTitle("Countries", displayMode: .inline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
