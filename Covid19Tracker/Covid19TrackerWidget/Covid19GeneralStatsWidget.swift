//
//  Covid19GeneralStatsWidget.swift
//  Covid19Tracker
//
//  Created by Maharjan Binish on 2020/07/13.
//

import WidgetKit
import SwiftUI

struct Covid19GeneralStatsProvider: TimelineProvider {
    typealias Entry = Covid19GeneralStatsEntry
    
    func snapshot(with context: Context, completion: @escaping (Covid19GeneralStatsEntry) -> ()) {
        let dummy = Covid19GeneralStats.default
        let entry = Covid19GeneralStatsEntry(date: Date(), stats: dummy)
        completion(entry)
    }
    
    func timeline(with context: Context, completion: @escaping (Timeline<Covid19GeneralStatsEntry>) -> ()) {
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 5, to: currentDate)!
        
        Covid19DataLoader.fetchGeneralStats { (result) in
            let stats: Covid19GeneralStats
            switch result {
            case .success(let fetchedData):
                stats = fetchedData
            case .failure:
                stats = Covid19GeneralStats.default
            }
            
            let entry = Covid19GeneralStatsEntry(date: currentDate, stats: stats)
            let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
            
            completion(timeline)
        }
    }
}

struct Covid19GeneralStatsEntry: TimelineEntry {
    public let date: Date
    public let stats: Covid19GeneralStats
}

struct GeneralStatsPlaceholderView: View {
    
    var body: some View {
        Covid19GeneralStatsEntryView(entry:  Covid19GeneralStatsEntry(date: Date(),
                                                                      stats: Covid19GeneralStats.default))
    }
}

struct Covid19GeneralStatsEntryView: View {
    var entry: Covid19GeneralStatsProvider.Entry
    
    var body: some View {
        Covid19GeneralStatsView(stats: entry.stats)
    }
}

struct Covid19GeneralStatsWidget: Widget {
    private let kind: String = "Covid19GeneralStatsWidget"
    
    public var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind,
                            provider: Covid19GeneralStatsProvider(),
                            placeholder: GeneralStatsPlaceholderView())
        { entry in
            Covid19GeneralStatsEntryView(entry: entry)
        }
        .supportedFamilies([.systemLarge])
        .configurationDisplayName("Covid19 General Stats")
        .description("Shows Latest Stats About Covid 19")
    }
}

struct Covid19GeneralStatsWidget_Previews: PreviewProvider {
    static var previews: some View {
        Covid19GeneralStatsEntryView(entry: Covid19GeneralStatsEntry(date: Date(),
                                                                     stats: Covid19GeneralStats.default))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
