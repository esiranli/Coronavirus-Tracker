//
//  CountryDetail.swift
//  CoronaVirusTracker
//
//  Created by EMRE on 24.03.2020.
//  Copyright © 2020 EMRE. All rights reserved.
//

import SwiftUI
import CoreLocation


struct CountryDetail: View {
    private let country: Country

    @ObservedObject var timelineObserver: TimelineObserver
    @State var pickerSelectedItem = 0
    
    init(country: Country) {
        self.country = country
        self.timelineObserver = TimelineObserver(country: country.country)
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    var backButton: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "arrow.left")
                    .padding()
                    .foregroundColor(Color("barColor"))
                .frame(width: 30, height: 30)
            }.navigationBarHidden(true)
        }
    }
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                VStack(alignment: .center, spacing: 8) {
                    Text(self.country.country)
                        .font(.system(size: 34))
                        .fontWeight(.heavy)
                    if (self.timelineObserver.historicalData != nil) {
                        Text(self.subtitle)
                            .font(.subheadline)
                            .fontWeight(.bold)
                        
                        HStack(alignment: .center, spacing: 2) {
                            ForEach(self.barData, id: \.self) { data in
                                BarView(data: data,
                                        maxValue: self.maxValue,
                                        width: self.getBarWidth(geometry: geometry)
                                )
                            }.animation(.default)
                        }.padding()
                    }
                                    
                    Picker(selection: self.$pickerSelectedItem, label: Text("asdasd")) {
                        ForEach(InfoType.chartableCases, id: \.self) { (type: InfoType) in
                            Text(type.description).tag(type.rawValue)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                        .padding()
                }
            }
        }.navigationBarItems(leading: backButton)
        
    }
    
    private var barData: [BarData] {
        return pickerSelectedItem == 0 ?
            timelineObserver.historicalData!.cases.sorted(by: { $0.text < $1.text }) :
            timelineObserver.historicalData!.deaths.sorted(by: { $0.text < $1.text })
    }
    
    private var maxValue: Int {
        return pickerSelectedItem == 0 ? self.timelineObserver.maxCaseValue : self.timelineObserver.maxDeathValue
    }
    
    func getBarWidth(geometry: GeometryProxy) -> CGFloat {
        let totalWidth: CGFloat = geometry.size.width - 16
        let totalSpacing = (barData.count - 1) * 2
        let totalBarCount = barData.count
        return CGFloat((totalWidth - CGFloat(totalSpacing)) / CGFloat(totalBarCount))
    }
    
    private var subtitle: String {
        let lastCase = timelineObserver.historicalData!.cases.sorted(by: { $0.text < $1.text }).last!
        let lastDeath = timelineObserver.historicalData!.deaths.sorted(by: { $0.text < $1.text }).last!
        return pickerSelectedItem == 0 ?
            "Total Cases: \(lastCase.value)\nLast Date: \(lastCase.text)" :
        "Total Deaths: \(lastDeath.value)\nLast Date: \(lastDeath.text)"
    }
}

class TimelineObserver: ObservableObject {
    
    @Published var historicalData: HistoricalData!
    @Published var maxCaseValue: Int!
    @Published var maxDeathValue: Int!
    
    init(country: String) {
        loadHistoricalData(country: country)
    }
    
    func loadHistoricalData(country: String) {
        let escapedCountry = country.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "USA"
        let urlString = "https://corona.lmao.ninja/v2/historical/\(escapedCountry)"
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            guard let data = data else { return }
    
            do {
                let decoder = JSONDecoder()
//                decoder.dateDecodingStrategy = .formatted(dateFormatter)
                let timelineData = try decoder.decode(TimelineData.self, from: data)
                DispatchQueue.main.async {
                    self.historicalData = timelineData.timeline
                    self.maxCaseValue = self.historicalData.cases.map { $0.value }.max(by: { ($0 < $1) }) ?? 0
                    self.maxDeathValue = self.historicalData.deaths.map { $0.value }.max(by: { ($0 < $1) }) ?? 0
                }
            } catch {
                print("Decoding error", error)
            }
        }.resume()
    }
    
}

struct BarView: View {
    var data: BarData
    var maxValue: Int
    var height: CGFloat = 300
    var width: CGFloat
    var body: some View {
//        VStack(spacing: 10) {
            ZStack(alignment: Alignment.bottom) {
                Capsule().frame(width: width, height: height).foregroundColor(.secondary)
                Capsule().foregroundColor(Color("barColor")).frame(width: width, height: CGFloat(data.value) * height / CGFloat(maxValue))
                    
            }
//            Text(data.text)
//                .frame(width: 14, height: 10)
//                .font(.system(size: 8))
//                .rotationEffect(Angle(degrees: 270), anchor: .center)
//        }
    }
}

struct CountryDetail_Previews: PreviewProvider {
    static var previews: some View {
        CountryDetail(country: countryData[10])
    }
}
