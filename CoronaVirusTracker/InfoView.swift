//
//  InfoView.swift
//  CoronaVirusTracker
//
//  Created by EMRE on 23.03.2020.
//  Copyright © 2020 EMRE. All rights reserved.
//

import SwiftUI

enum InfoType: Int, CustomStringConvertible, CaseIterable {
    case confirmed
    case deaths
    case recovered
    
    var color: Color {
        switch self {
        case .confirmed:
            return .gray
        case .deaths:
            return .red
        case .recovered:
            return .green
        }
    }
    
    var description: String {
        switch self {
        case .confirmed:
            return "Confirmed"
        case .deaths:
            return "Deaths"
        case .recovered:
            return "Recovered"
        }
    }
    
    static let chartableCases: [InfoType] = [.confirmed, .deaths]
}

struct InfoView: View {
    let subtitle: String
    let info: String
    let type: InfoType
    
    var body: some View {
        Group {
                VStack(alignment: .center, spacing: 4) {
                    Text(type.description)
                        .font(.caption)
                    if !subtitle.isEmpty {
                        Text(subtitle)
                        .font(.system(size: 12, weight: .bold, design: .default))
                    }
                    Text(info)
                        .font(.headline)
                        .fontWeight(.heavy)
                }
                .padding(8)
                .frame(minWidth: 0, maxWidth: .infinity)
        }.background(type.color)
            .cornerRadius(4)
            .shadow(radius: 4)
    }
        
}

struct InfoChart: View {
    
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack (alignment: .leading, spacing: 16) {
            
            Button(action: {
                self.isPresented = false
            }, label: {
                HStack {
                    Spacer()
                    Text("Cancel")
                        .fontWeight(.bold)
                        .padding(.vertical, 12)
                }
            })
            Spacer()
            
        }.padding(.all, 20)
        
    }
}


struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView(subtitle: "+1234", info: "23,345", type: .deaths)
    }
}
