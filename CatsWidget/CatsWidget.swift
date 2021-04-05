//
//  CatsWidget.swift
//  CatsWidget
//
//  Created by Пользователь on 31.03.2021.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    let downloaderCatsWidget = DownloaderCatsWidget()
    func placeholder(in context: Context) -> CatsWidgetEntry {
        CatsWidgetEntry(date: Date(), image: UIImage())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (CatsWidgetEntry) -> ()) {
        var entry = CatsWidgetEntry(date: Date(), image: UIImage())
        downloaderCatsWidget.loadImage { image in
            entry.image = image
            completion(entry)
        }
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var currentDate = Date()
        let endDate = Calendar.current.date(byAdding: .minute, value: 2, to: currentDate)!
        while currentDate < endDate {
            
            downloaderCatsWidget.loadImage { image in
                var entries: [CatsWidgetEntry] = []
                let entry = CatsWidgetEntry (date: currentDate, image: image)
                entries.append(entry)
                let timeline = Timeline(entries: entries, policy: .atEnd)
                completion(timeline)
            }
            currentDate = Calendar.current.date(byAdding: .second, value: 12, to: currentDate)!
            WidgetCenter.shared.reloadTimelines(ofKind: "CatsWidget")
        }
        
        //
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        //        let currentDate = Date()
        //        for hourOffset in 0 ..< 5 {
        //
        //            let entryDate = Calendar.current.date(byAdding: .minute, value: hourOffset, to: currentDate)!
        //
        //            downloaderCatsWidget.loadImage { image in
        //                var entries: [CatsWidgetEntry] = []
        //                let entry = CatsWidgetEntry (date: entryDate, image: image)
        //                entries.append(entry)
        //                        let timeline = Timeline(entries: entries, policy: .atEnd)
        //            completion(timeline)
        //            }
        //            WidgetCenter.shared.reloadTimelines(ofKind: "CatsWidget")
        //        }
        
        
    }
}

struct CatsWidgetEntry: TimelineEntry {
    let date: Date
    var image: UIImage
}

struct CatsWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        Image(uiImage: entry.image )
            .resizable()
            .frame(width: 148.0, height: 148.0)
            .aspectRatio(contentMode: .fit)
    }
}

@main
struct CatsWidget: Widget {
    let kind: String = "CatsWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            CatsWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("CatsForever")
        .description("This is Cat's widget.")
    }
    
}

struct CatsWidget_Previews: PreviewProvider {
    static var previews: some View {
        CatsWidgetEntryView(entry: CatsWidgetEntry(date: Date(), image: UIImage()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
