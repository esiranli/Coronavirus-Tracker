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
//    @Binding var isPresented: Bool
    
    private var maxValue: Int {
        let selectedData = pickerSelectedItem == 0 ? timelineObserver.historicalData!.cases : timelineObserver.historicalData!.deaths
        return selectedData.map { $0.value }.max(by: { ($0 > $1) }) ?? 0
    }
    
    init(country: Country) {
        self.country = country
        self.timelineObserver = TimelineObserver(country: country.country)
    }
    
    var body: some View {
        ZStack {
            Color(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)).edgesIgnoringSafeArea(.all)
            VStack(alignment: .center, spacing: 8) {
                Text(country.country)
                    .font(.system(size: 34))
                    .fontWeight(.heavy)
                if (timelineObserver.historicalData != nil) {
                    Text(getSubtitle())
                        .font(.subheadline)
                        .fontWeight(.bold)
                        
                    HStack(alignment: .center, spacing: 2) {
                        ForEach(getBarData(pickerSelectedItem: pickerSelectedItem), id: \.self) { data in
                            BarView(data: data, maxValue: (self.pickerSelectedItem == 0) ? self.timelineObserver.maxCaseValue : self.timelineObserver.maxDeathValue)
                        }.animation(.default)
                    }
                }
                                
                Picker(selection: $pickerSelectedItem, label: Text("asdasd")) {
                    ForEach(InfoType.chartableCases, id: \.self) { (type: InfoType) in
                        Text(type.description).tag(type.rawValue)
                    }
                }.pickerStyle(SegmentedPickerStyle())
                    .padding()
            }
        }
    }
    
    func getBarData(pickerSelectedItem: Int) -> [BarData] {
        return pickerSelectedItem == 0 ?
            timelineObserver.historicalData!.cases.sorted(by: { $0.text < $1.text }) :
            timelineObserver.historicalData!.deaths.sorted(by: { $0.text < $1.text })
    }
    
    func getSubtitle() -> String {
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
        let urlString = "https://corona.lmao.ninja/v2/historical/\(country)"
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
    var body: some View {
        VStack(spacing: 10) {
            ZStack(alignment: .bottom) {
                Capsule().frame(width: 4, height: 300).foregroundColor(Color(#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)))
                Capsule().frame(width: 4, height: CGFloat(data.value * 200 / maxValue))
                    .foregroundColor(.white)
            }
//            Text(data.text)
//                .frame(width: 14, height: 10)
//                .font(.system(size: 8))
//                .rotationEffect(Angle(degrees: 270), anchor: .center)
        }
    }
}

struct CountryDetail_Previews: PreviewProvider {
    static var previews: some View {
        CountryDetail(country: countryData[10])
    }
}