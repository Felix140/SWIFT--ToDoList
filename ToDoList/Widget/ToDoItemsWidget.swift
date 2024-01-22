import SwiftUI
import WidgetKit

struct ToDoItemsWidget: Widget {
    private let kind = "TooDoo Widget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            EntryView(entry: entry)
        }
        .configurationDisplayName("TooDoo Widget")
        .description("See your tasks.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

// MARK: - Entry Struct

extension ToDoItemsWidget {
    struct Entry: TimelineEntry {
        let date: Date
        let documentNames: [String]
        
        static var placeholder: Self {
            .init(date: .now, documentNames: ["Loading..."])
        }
    }
}

// MARK: - EntryView

extension ToDoItemsWidget {
    struct EntryView: View {
        let entry: Entry
        
        var body: some View {
            VStack(alignment: .leading, spacing: 5) {
                Text("Firestore Data").font(.headline)
                ForEach(entry.documentNames, id: \.self) { documentName in
                    Text(documentName).font(.caption)
                }
            }
            .widgetBackground(Color.black)
            .padding(12)
        }
    }
}

extension View {
    func widgetBackground(_ backgroundView: some View) -> some View {
        if #available(iOSApplicationExtension 17.0, *) {
            return containerBackground(for: .widget) {
                backgroundView
            }
        } else {
            return background(backgroundView)
        }
    }
}


// MARK: - Provider

extension ToDoItemsWidget {
    class Provider: TimelineProvider {
        func placeholder(in context: Context) -> Entry {
            .placeholder
        }
        
        func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
            completion(.placeholder)
        }
        
        func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
            
            let arrTest: [String] = ["Task 1", "Task 2", "Task 3", "Task 4"]
            let entry = Entry(date: Date(), documentNames: arrTest)
            completion(Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(3600))))
        }
    }
}
