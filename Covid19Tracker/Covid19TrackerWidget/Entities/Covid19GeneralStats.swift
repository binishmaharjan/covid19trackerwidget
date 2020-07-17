//
//  Covid19GeneralStats.swift
//  Covid19Tracker
//
//  Created by Maharjan Binish on 2020/07/13.
//

import Foundation

struct Covid19GeneralStats: Decodable {
    var totalCases: String = ""
    var recoveryCases: String = ""
    var deathCases: String = ""
    var lastUpdate: String = ""
    var currentlyInfected: String = ""
    var casesWithOutcome: String = ""
    var mildConditionActiveCases: String = ""
    var criticalConditionActiveCases: String = ""
    var recoveredClosedCases: String = ""
    var deathClosedCases: String = ""
    var closedCasesRecoveredPercentage: String = ""
    var closedCasesDeathPercentage: String = ""
    var activeCasesMildPercentage: String = ""
    var activeCasesCriticalPercentage: String = ""
    var generalDeathRate: String = ""
    var status: String = ""
    
    private enum MainKeys: String, CodingKey {
        case data
        case status
    }
    
    private enum Datakeys: String, CodingKey {
        case totalCases = "total_cases"
        case recoveryCases = "recovery_cases"
        case deathCases = "death_cases"
        case lastUpdate = "last_update"
        case currentlyInfected = "currently_infected"
        case casesWithOutcome = "cases_with_outcome"
        case mildConditionActiveCases = "mild_condition_active_cases"
        case criticalConditionActiveCases = "critical_condition_active_cases"
        case recoveredClosedCases = "recovered_closed_cases"
        case deathClosedCases = "death_closed_cases"
        case closedCasesRecoveredPercentage = "closed_cases_recovered_percentage"
        case closedCasesDeathPercentage = "closed_cases_death_percentage"
        case activeCasesMildPercentage = "active_cases_mild_percentage"
        case activeCasesCriticalPercentage = "active_cases_critical_percentage"
        case generalDeathRate = "general_death_rate"
    }
    
    static var `default` = Covid19GeneralStats(totalCases: "N/A",
                                               recoveryCases: "N/A",
                                               deathCases: "N/A",
                                               lastUpdate: "XXX, 00 0000, 00:00, UTC",
                                               currentlyInfected: "N/A",
                                               casesWithOutcome: "N/A",
                                               mildConditionActiveCases: "N/A",
                                               criticalConditionActiveCases: "N/A",
                                               recoveredClosedCases: "N/A",
                                               deathClosedCases: "N/A",
                                               closedCasesRecoveredPercentage: "N/A",
                                               closedCasesDeathPercentage: "N/A",
                                               activeCasesMildPercentage: "N/A",
                                               activeCasesCriticalPercentage: "N/A",
                                               generalDeathRate: "N/A",
                                               status: "success")
}

extension Covid19GeneralStats {
    init(from decoder: Decoder) throws {
        if let mainContainer = try? decoder.container(keyedBy: MainKeys.self) {
            if let dataContainer = try? mainContainer.nestedContainer(keyedBy: Datakeys.self, forKey: .data) {
                self.totalCases = try dataContainer.decode(String.self, forKey: .totalCases)
                self.recoveryCases = try dataContainer.decode(String.self, forKey: .recoveryCases)
                self.deathCases = try dataContainer.decode(String.self, forKey: .deathCases)
                self.lastUpdate = try dataContainer.decode(String.self, forKey: .lastUpdate)
                self.currentlyInfected = try dataContainer.decode(String.self, forKey: .currentlyInfected)
                self.casesWithOutcome = try dataContainer.decode(String.self, forKey: .casesWithOutcome)
                self.mildConditionActiveCases = try dataContainer.decode(String.self, forKey: .mildConditionActiveCases)
                self.criticalConditionActiveCases = try dataContainer.decode(String.self, forKey: .criticalConditionActiveCases)
                self.recoveredClosedCases = try dataContainer.decode(String.self, forKey: .recoveredClosedCases)
                self.deathClosedCases = try dataContainer.decode(String.self, forKey: .deathClosedCases)
                self.closedCasesRecoveredPercentage = try dataContainer.decode(String.self, forKey: .closedCasesRecoveredPercentage)
                self.closedCasesDeathPercentage = try dataContainer.decode(String.self, forKey: .closedCasesDeathPercentage)
                self.activeCasesMildPercentage = try dataContainer.decode(String.self, forKey: .activeCasesMildPercentage)
                self.generalDeathRate = try dataContainer.decode(String.self, forKey: .generalDeathRate)
            }
            
            self.status = try mainContainer.decode(String.self, forKey: .status)
        }
    }
}
