//
//  Covid19TrackerWidget.swift
//  Covid19TrackerWidget
//
//  Created by Maharjan Binish on 2020/07/10.
//

import WidgetKit
import SwiftUI
import Intents

struct Covid19CountryStatusIntentProvider: IntentTimelineProvider {
    typealias Entry = Covid19CountryStatusEntry
    typealias Intent = CountrySelectIntent
    
    ///　Intentに設定されたOptionを文字列に変換するhelper method
    func country(for configuration: CountrySelectIntent) -> String {
        switch configuration.country {
        
        case .unknown, .japan:
            return "jap"
        case .usa:
            return "usa"
        case .korea:
            return "kor"
        case .china:
            return "chi"
        }
    }
    
    func snapshot(for configuration: CountrySelectIntent, with context: Context, completion: @escaping (Covid19CountryStatusEntry) -> ()) {
        let dummy = Covid19CountryStatus.default
        let entry = Covid19CountryStatusEntry(date: Date(), status: dummy)
        completion(entry)
    }
    
    func timeline(for configuration: CountrySelectIntent, with context: Context, completion: @escaping (Timeline<Covid19CountryStatusEntry>) -> ()) {
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 5, to: currentDate)!
        let selectedCountry = country(for: configuration)
        
        Covid19DataLoader.fetch(by: selectedCountry) { (result) in
            let country: Covid19CountryStatus
            switch result {
            case .success(let fetchedData):
                country = fetchedData
            case .failure:
                country = Covid19CountryStatus.default
            }
            
            let entry = Covid19CountryStatusEntry(date:currentDate, status: country)
            let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
            
            completion(timeline)
        }
    }
}

struct Covid19CountryStatusProvider: TimelineProvider {
    
    typealias Entry = Covid19CountryStatusEntry
    
    func snapshot(with context: Context, completion: @escaping (Covid19CountryStatusEntry) -> ()) {
        let dummy = Covid19CountryStatus.default
        let entry = Covid19CountryStatusEntry(date: Date(), status: dummy)
        completion(entry)
    }
    
    func timeline(with context: Context, completion: @escaping (Timeline<Covid19CountryStatusEntry>) -> ()) {
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 5, to: currentDate)!
        
        Covid19DataLoader.fetch { (result) in
            let country: Covid19CountryStatus
            switch result {
            case .success(let fetchedData):
                country = fetchedData
            case .failure:
                country = Covid19CountryStatus.default
            }
            
            let entry = Covid19CountryStatusEntry(date:currentDate, status: country)
            let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
            
            completion(timeline)
        }
    }
}

struct Covid19CountryStatusEntry: TimelineEntry {
    
    public let date: Date
    public let status: Covid19CountryStatus
}

struct PlaceholderView: View {
    
    var body: some View{
        Covid19CountryStatusEntryView(entry: Covid19CountryStatusEntry(date: Date(),
                                                                       status: Covid19CountryStatus.default))
            //.isPlaceholder(true)  // Might be avaiable in the later versions.
    }
}

struct Covid19CountryStatusEntryView: View {
    
    @Environment(\.widgetFamily) var family: WidgetFamily
    var entry: Covid19CountryStatusProvider.Entry
    
    @ViewBuilder
    var body: some View{
        switch family {
        case .systemSmall:
            CountryStatusWidgetView(status: entry.status)
        default:
            CountryStatusWidgetMediumView(status: entry.status)
        }
    }
}

@main
struct Covid19TrackerWidget: Widget {
    private let kind: String = "Covid19TrackerWidget"

//        public var body: some WidgetConfiguration {
//            StaticConfiguration(kind: kind,
//                                provider: Covid19CountryStatusProvider(),
//                                placeholder: PlaceholderView())
//            { entry in
//                Covid19CountryStatusEntryView(entry: entry)
//            }
//            .supportedFamilies([.systemSmall, .systemMedium])
//            .configurationDisplayName("Covid19 Tracker")
//            .description("Shows Latest Information About Covid 19")
//        }
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind,
                            intent: CountrySelectIntent.self,
                            provider: Covid19CountryStatusIntentProvider(),
                            placeholder: PlaceholderView())
        { entry in
            Covid19CountryStatusEntryView(entry: entry)
        }
        .supportedFamilies([.systemSmall, .systemMedium])
        .configurationDisplayName("Covid19 Tracker")
        .description("Shows Latest Information About Covid 19")
    }
}


struct Covid19TrackerWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Covid19CountryStatusEntryView(entry: Covid19CountryStatusEntry(date:Date(),status: Covid19CountryStatus.default))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            
            Covid19CountryStatusEntryView(entry: Covid19CountryStatusEntry(date:Date(), status: Covid19CountryStatus.default))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
        }

    }
}


