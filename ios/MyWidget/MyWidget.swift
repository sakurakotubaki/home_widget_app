//
//  MyWidget.swift
//  MyWidget
//
//  Created by 橋本純一 on 2026/02/23.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), counter: 0, message: "Widget")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), counter: 0, message: "Widget")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let userDefaults = UserDefaults(suiteName: "group.com.jboycode.homeWidgetApp")
        
        let counter = userDefaults?.integer(forKey: "counter") ?? 0
        let message = userDefaults?.string(forKey: "message") ?? "Widget"
        
        let entry = SimpleEntry(date: Date(), counter: counter, message: message)
        let timeline = Timeline(entries: [entry], policy: .after(Date(timeIntervalSinceNow: 300)))
        completion(timeline)
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let counter: Int
    let message: String
}

struct MyWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            Text(entry.message)
                .font(.headline)
            
            Text("\(entry.counter)")
                .font(.system(size: 48, weight: .bold))
            
            Text(entry.date, style: .time)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

struct MyWidget: Widget {
    let kind: String = "MyWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                MyWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                MyWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemSmall) {
    MyWidget()
} timeline: {
    SimpleEntry(date: .now, counter: 0, message: "Widget")
    SimpleEntry(date: .now, counter: 5, message: "Widget")
}
