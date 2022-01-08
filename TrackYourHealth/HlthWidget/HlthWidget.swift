//
//  HlthWidget.swift
//  HlthWidget
//
//  Created by Jared Watson on 1/7/22.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), text: "", configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), text: "", configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        let userDefaults = UserDefaults(suiteName: "group.widgetcache")
        let text = userDefaults?.value(forKey: "text") as? String ?? "No Text"
        
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, text: text, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let text: String
    let configuration: ConfigurationIntent
}

struct HlthWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            GeometryReader { geo in
                Image("background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
             }
            Text(entry.text)
                .foregroundColor(Color.white)
                .font(Font.system(size: 24, weight: .semibold, design: .default))
        }
    }
}

@main
struct HlthWidget: Widget {
    let kind: String = "HlthWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            HlthWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct HlthWidget_Previews: PreviewProvider {
    static var previews: some View {
        HlthWidgetEntryView(entry: SimpleEntry(date: Date(), text: "Hello widget", configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
