//
//  CountryList.swift
//  CoronaVirusTracker
//
//  Created by EMRE on 2.04.2020.
//  Copyright © 2020 EMRE. All rights reserved.
//

import SwiftUI

struct CountryList: View {
    @EnvironmentObject
    private var countryStore: CountryStore
    
    @State private var isShowing = false
    
    @State private var searchTerm = ""
    
    var filteredCountries: [Country] {
        return countryStore.countries.filter{ searchTerm.isEmpty ? true : $0.country.lowercased().contains(searchTerm.lowercased())}
    }
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(query: $searchTerm, placeholder: "Search")
                List(filteredCountries) { country in
                    NavigationLink(destination: CountryDetail(country: country)) {
                        CountryRow(data: country) { () -> ImageViewContainer in
                            ImageViewContainer(imageURL: country.countryInfo.flag)
                        }
                    }.isDetailLink(false)
                    
                }.background(PullToRefresh(action: {
                        self.countryStore.load(completion: { completed in
                            self.isShowing = false
                        })
                    }, isShowing: $isShowing))
                    .navigationBarTitle("Countries", displayMode: .inline)
            }
        }
    }
}

struct CountryList_Previews: PreviewProvider {
    static var previews: some View {
        CountryList()
    }
}
