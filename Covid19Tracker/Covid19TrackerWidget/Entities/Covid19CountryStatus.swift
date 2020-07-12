//
//  CountryData.swift
//  Covid19Tracker (iOS)
//
//  Created by Maharjan Binish on 2020/07/10.
//

import Foundation

struct Country: Decodable {
    let country: String
    let countryAbbreviation: String
    let totalCases: String
    let newCases: String
    let totalDeaths: String
    let newDeaths: String
    let totalRecovered: String
    let activeCases: String
    let seriousCritical: String
    let casesPerMillPop: String
    let flag: String
    
    enum CodingKeys: String, CodingKey {
        case country
        case countryAbbreviation = "country_abbreviation"
        case totalCases = "total_cases"
        case newCases = "new_cases"
        case totalDeaths = "total_deaths"
        case newDeaths = "new_deaths"
        case totalRecovered = "total_recovered"
        case activeCases = "active_cases"
        case seriousCritical = "serious_critical"
        case casesPerMillPop = "cases_per_mill_pop"
        case flag
    }
    
    static var `default`: Country = Country(country: "Country",
                                            countryAbbreviation: "XX",
                                            totalCases: "N/A",
                                            newCases: "N/A",
                                            totalDeaths: "N/A",
                                            newDeaths: "N/A",
                                            totalRecovered: "N/A",
                                            activeCases: "N/A",
                                            seriousCritical: "N/A",
                                            casesPerMillPop: "N/A",
                                            flag: "https://www.worldometers.info/img/flags/ja-flag.gif")
}

struct Covid19CountryStatus: Decodable {
    var lastUpdated: String = ""
    var status: String = ""
    var countries: [Country] = [Country]()
    
    private enum MainKeys: String, CodingKey {
        case data
        case status
    }
    
    private enum DataKeys: String, CodingKey {
        case lastUpdated = "last_update"
        case countries = "rows"
    }
    
    static var `default`: Covid19CountryStatus = Covid19CountryStatus(lastUpdated: "XXX, 00 0000, 00:00, UTC",
                                                                      status: "success",
                                                                      countries: [Country.default])
}

extension Covid19CountryStatus {
    init(from decoder: Decoder) throws {
        if let mainContainer = try? decoder.container(keyedBy: MainKeys.self) {
            if let dataContainer = try? mainContainer.nestedContainer(keyedBy: DataKeys.self, forKey: .data) {
                self.lastUpdated = try dataContainer.decode(String.self, forKey: .lastUpdated)
                
                self.countries = try dataContainer.decode([Country].self, forKey: .countries)
            }
            
            self.status = try mainContainer.decode(String.self, forKey: .status)
        }
    }
}
