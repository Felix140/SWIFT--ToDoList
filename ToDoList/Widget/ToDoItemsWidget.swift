import SwiftUI
import WidgetKit
import Intents
import Firebase

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
            
            
            fetchDataFromFirebase { documentNames in
                let entry = Entry(date: Date(), documentNames: documentNames)
                completion(Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(3600))))
            }
        }
        
        func fetchDataFromFirebase(completion: @escaping ([String]) -> Void) {
            let db = Firestore.firestore()

            var arrTest: [String] = []

            db.collection("users").document("fcEziy2Qz7ONdyXCdqwVEefgOG02").collection("todos").getDocuments { (querySnapshot, error) in
                do {
                    if let error = error {
                        throw error
                    }

                    for document in querySnapshot!.documents {
                        let data = document.data()

                        if let taskTitle = data["title"] as? String {
                            arrTest.append(taskTitle)
                        }
                    }

                    completion(arrTest)
                } catch {
                    print("Errore nel recupero dei dati da Firebase: \(error)")
                    arrTest.append("ciaeeee")
                    completion(arrTest)
                }
            }
        }

    }
}
