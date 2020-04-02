//
//  Data.swift
//  CoronaVirusTracker
//
//  Created by EMRE on 22.03.2020.
//  Copyright © 2020 EMRE. All rights reserved.
//

import Foundation
import CoreLocation

let locationData: LocationData = load("locations.json")
let countryData: [Country] = load("countries.json")

var dateFormatter: DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd/yy"
    return dateFormatter
}

var displayDateFormatter: DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
    return dateFormatter
}

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}


//MARK: old api models
struct LocationData: Decodable {
    let latest: Latest
    let locations: [Location]
}

struct Latest: Decodable {
    let confirmed, deaths, recovered: Int
}

struct Location: Decodable, Identifiable {
    fileprivate let coordinates: Coordinate
    let country: String
    let country_code: String
    var id: Int
    let last_updated: String
    let latest: Latest
    let province: String
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: Double(coordinates.latitude)!, longitude: Double(coordinates.longitude)!)
    }
}

struct Coordinate: Decodable {
    let latitude, longitude: String
}

//MARK: new api models

struct Country: Decodable, Identifiable {
    let country: String
    let countryInfo: CountryInfo
    var id: Int {
        countryInfo._id ?? -99
    }
//    var coordinate: CLLocationCoordinate2D {
//        return CLLocationCoordinate2D(latitude: countryInfo.lat, longitude: countryInfo.long)
//    }
    let cases, todayCases, deaths, todayDeaths, recovered, active, critical: Int
    let casesPerOneMillion, deathsPerOneMillion: Double?
}

struct CountryInfo: Decodable {
    var iso2, iso3: String?
    var flag: String
    var _id: Int?
    var lat, long: Double
    
    enum CodingKeys: CodingKey {
        case iso2, iso3, flag, _id, lat, long
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        iso2 = try container.decodeIfPresent(String.self, forKey: .iso2)
        iso3 = try container.decodeIfPresent(String.self, forKey: .iso3)
        flag = try container.decode(String.self, forKey: .flag)
        if let value = try? container.decodeIfPresent(Int.self, forKey: ._id) {
            _id = value
        } else {
            _id = Int.random(in: 1000..<100000) * -1
        }
        lat = try container.decode(Double.self, forKey: .lat)
        long = try container.decode(Double.self, forKey: .long)
    }
}

struct TimelineData: Decodable {
    let country: String
    let timeline: HistoricalData
}

struct HistoricalData: Decodable {
    let cases: [BarData]
    let deaths: [BarData]
    
    enum CodingKeys: CodingKey {
        case cases, deaths
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        cases = try container.decode([String: Int].self, forKey: .cases)
            .map({ BarData(text: dateFormatter.date(from: $0.key) ?? Date(), value: $0.value)})
        deaths = try container.decode([String: Int].self, forKey: .deaths)
                        .map({ BarData(text: dateFormatter.date(from: $0.key) ?? Date(), value: $0.value)})
    }
}

struct BarData: Decodable, Hashable {
    let text: Date
    let value: Int
}

struct WorldData: Decodable {
    let cases, deaths, recovered, active, affectedCountries: Int
    let updated: Date
    
    enum CodingKeys: CodingKey {
        case cases, deaths, recovered, active, affectedCountries, updated
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        cases = try container.decode(Int.self, forKey: .cases)
        deaths = try container.decode(Int.self, forKey: .deaths)
        recovered = try container.decode(Int.self, forKey: .recovered)
        active = try container.decode(Int.self, forKey: .active)
        affectedCountries = try container.decode(Int.self, forKey: .affectedCountries)
        let dateTime = try container.decode(Double.self, forKey: .updated)
        updated = Date(timeIntervalSince1970: dateTime / 1000.0)
    }
}
