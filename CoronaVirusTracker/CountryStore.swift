//
//  CountryStore.swift
//  CoronaVirusTracker
//
//  Created by EMRE on 24.03.2020.
//  Copyright © 2020 EMRE. All rights reserved.
//

import SwiftUI
import Combine

final class CountryStore: ObservableObject {
    
    @Published
    var countries = [Country]()
    
    @Published
    var timeline: TimelineData!
    
    @State
    private var searchTerm = ""
    
    @State var dataPoints: [[BarData]] = []
    @State var countryName = ""

    init() {
        load()
    }
    
    var filteredCountries: [Country] {
        return countries.filter{ searchTerm.isEmpty ? true : $0.country.lowercased().contains(searchTerm.lowercased())}
    }
    
    func load(completion: ((Bool) -> ())? = nil) {
        let urlString = "https://corona.lmao.ninja/countries"
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            guard let data = data else { return }

            do {
                let countries = try JSONDecoder().decode([Country].self, from: data)
                DispatchQueue.main.async {
                    self.countries = countries
                    completion?(true)
                }
            } catch {
                print("Decoding error", error)
                completion?(false)
            }
        }.resume()
    }
}

