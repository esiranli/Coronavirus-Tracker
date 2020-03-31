//
//  CountryRow.swift
//  CoronaVirusTracker
//
//  Created by EMRE on 22.03.2020.
//  Copyright © 2020 EMRE. All rights reserved.
//

import SwiftUI

struct CountryRow: View {
    var data: Country
    var imageContent: () -> ImageViewContainer
    
    var body: some View {
        VStack(alignment: HorizontalAlignment.leading) {
            HStack(alignment: .center, spacing: 16) {
                imageContent()
                Text(data.country)
                .font(.title)
                .padding(.bottom, 8)
                .offset(y: 5)
            }
            
            HStack(alignment: .center, spacing: 8) {
                InfoView(subtitle: data.todayCases > 0 ? "+\(data.todayCases)" : "", info: "\(data.cases)", type: .confirmed)
                InfoView(subtitle: data.todayDeaths > 0 ? "+\(data.todayDeaths)" : "", info: "\(data.deaths)", type: .deaths)
                InfoView(subtitle: "", info: "\(data.recovered)", type: .recovered)
            }
        }
    }
}

//struct LocationRow_Previews: PreviewProvider {
//    static var previews: some View {
//        CountryRow(data: countryData[1])
//            .previewLayout(.fixed(width: 500, height: 150))
//    }
//}
