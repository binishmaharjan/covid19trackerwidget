//
//  Covid19WidgetView.swift
//  Covid19Tracker (iOS)
//
//  Created by Maharjan Binish on 2020/07/10.
//

import SwiftUI

// MARK: Widget Small View
struct CountryStatusWidgetView: View {
    let status: Covid19CountryStatus
    
    var body: some View {
        ZStack {
            Image("covid19")
                .resizable()
            
            VStack() {
                TitleView(country: status.countries.first!.country,
                          lastUpdatedDate: status.lastUpdated.displayDate)
                
                InfoRowView(infos: [
                    InfoData(title: "New Cases", data: status.countries.first!.newCases),
                    InfoData(title: "Total Cases", data: status.countries.first!.totalCases)
                ])
                
                Spacer()
            }
            .padding()
        }
    }
}

// MARK: Widget Medium View
struct CountryStatusWidgetMediumView: View {
    let status: Covid19CountryStatus
    
    var body: some View {
        ZStack {
            Image("covid19-medium")
                .resizable()
            
            VStack() {
                TitleView(country: status.countries.first!.country,
                          lastUpdatedDate: status.lastUpdated.displayDate)
                
                HStack{
                    InfoRowView(infos: [
                        InfoData(title: "New Cases", data: status.countries.first!.newCases),
                        InfoData(title: "Total Cases", data: status.countries.first!.totalCases)
                    ])
                    
                    Spacer()
                    
                    InfoRowView(infos: [
                        InfoData(title: "Active Cases", data: status.countries.first!.activeCases),
                        InfoData(title: "Total Recovered", data: status.countries.first!.totalRecovered)
                    ])
                    
                    Spacer()
                    
                    InfoRowView(infos: [
                        InfoData(title: "Serious Cases", data: status.countries.first!.seriousCritical),
                        InfoData(title: "Total Death", data: status.countries.first!.totalDeaths)
                    ])
                }
                Spacer()
            }
            .padding()
        }
    }
}

// MARK: Widget Title
struct TitleView: View {
    var country: String
    var lastUpdatedDate: String
    
    var body: some View {
        VStack {
            Text(country)
                .font(.headline)
            
            TrailingText(string: lastUpdatedDate)
                .font(Font.system(size: 12))
            
            Spacer()
                .frame(height: 8)
        }
    }
}

// MARK: Widget Single Info View
struct InfoData: Hashable {
    let title: String
    let data: String
}

struct InfoView: View {
    let info: InfoData
    
    var body: some View {
        VStack {
            Text(info.data)
                .font(.headline)
                .padding(.bottom, 3)
            
            Text(info.title)
                .font(.subheadline)
                .padding(.bottom, 3)
        }
    }
}

struct InfoRowView: View {
    var infos: [InfoData]
    
    var body: some View {
        VStack {
            ForEach(infos, id: \.self) { info in
                InfoView(info: info)
            }
        }
    }
}

// MARK: Helper View
struct TrailingText: View {
    
    let string: String
    
    var body: some View {
        HStack {
            Spacer()
            Text(string)
        }
    }
}

struct LeadingText: View {
    
    let string: String
    
    var body: some View {
        HStack {
            Text(string)
                .bold()
                .lineLimit(1)
                .minimumScaleFactor(0.5)

            Spacer()
        }
    }
}
