//
//  Covid19GeneralStatsView.swift
//  Covid19Tracker
//
//  Created by Maharjan Binish on 2020/07/14.
//

import SwiftUI
import WidgetKit

struct Covid19GeneralStatsView: View {
    
    var stats: Covid19GeneralStats
    
    let sharedContainerURL: URL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.binish.Covid19Tracker")!
    var bgImage: UIImage? {
        let filePath = sharedContainerURL.appendingPathComponent("bg.png")
        do {
            let data = try Data(contentsOf: filePath)
            let uiimage = UIImage(data: data)
            return uiimage
        } catch {
            return nil
        }
    }
    
    var body: some View {
        ZStack {
            if bgImage != nil {
                Image(uiImage: bgImage!)
                    .resizable()
            }
            
            VStack {
                TitleView(title: "Covid 19 General Stats",
                          lastUpdatedDate: stats.lastUpdate.displayDate)
                
                HStack {
                    VStack {
                        VStack {
                            LeadingText(string: "Total Cases:").padding(.bottom, 3)
                            LeadingText(string: "Currently Infected:").padding(.bottom, 3)
                            LeadingText(string: "Mild Condition:").padding(.bottom, 3)
                            LeadingText(string: "Critical Condition:").padding(.bottom, 3)
                            LeadingText(string: "Death Cases:").padding(.bottom, 3)
                            LeadingText(string: "Recovered Cases:").padding(.bottom, 3)
                        }
                        
                        VStack {
                            LeadingText(string: "Recovered Percentage:").padding(.bottom, 3)
                            LeadingText(string: "Death Percentage:").padding(.bottom, 3)
                            LeadingText(string: "MildPercentage:").padding(.bottom, 3)
                            LeadingText(string: "Critical Percentage:").padding(.bottom, 3)
                            LeadingText(string: "Death Rate:").padding(.bottom, 3)
                        }
                    }
                    
                    Spacer().frame(width: 16)
                    
                    VStack {
                        VStack {
                            LeadingText(string: stats.totalCases).padding(.bottom, 3)
                            LeadingText(string: stats.currentlyInfected).padding(.bottom, 3)
                            LeadingText(string: stats.mildConditionActiveCases).padding(.bottom, 3)
                            LeadingText(string: stats.criticalConditionActiveCases).padding(.bottom, 3)
                            LeadingText(string: stats.deathClosedCases).padding(.bottom, 3)
                            LeadingText(string: stats.recoveredClosedCases).padding(.bottom, 3)
                        }
                        
                        VStack {
                            LeadingText(string: stats.recoveryCases).padding(.bottom, 3)
                            LeadingText(string: stats.closedCasesDeathPercentage).padding(.bottom, 3)
                            LeadingText(string: stats.activeCasesMildPercentage).padding(.bottom, 3)
                            LeadingText(string: stats.activeCasesCriticalPercentage).padding(.bottom, 3)
                            LeadingText(string: stats.generalDeathRate).padding(.bottom, 3)
                        }
                    }
                }
                
                
                Spacer()
            }
            .padding()
        }
    }
}

struct Covid19GeneralStatsView_Previews: PreviewProvider {
    static var previews: some View {
        Covid19GeneralStatsView(stats: Covid19GeneralStats.default)
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
