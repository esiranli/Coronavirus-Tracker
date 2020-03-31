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
    
    @State var isPresentingChart = false
    
    var body: some View {
        NavigationView {
            List(countryStore.filteredCountries) { country in
                NavigationLink(destination: CountryDetail(country: country)) {
                    CountryRow(data: country) { () -> ImageViewContainer in
                        ImageViewContainer(imageURL: country.countryInfo.flag)
                    }
                }
//                Button(action: { self.isPresentingChart.toggle() }) {
//                    CountryRow(data: country, imageContent: {
//                        ImageViewContainer(imageURL: country.countryInfo.flag)
//                    })
//                }.sheet(isPresented: self.$isPresentingChart) {
//                    CountryDetail(country: country)
//                }
            }.navigationBarTitle("Countries")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
