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
        var tasks: [String] {
            return entry.documentNames
        }
        
        var body: some View {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Task for Today:").font(.headline)
                    ForEach(entry.documentNames, id: \.self) { documentName in
                        HStack {
                            Image(systemName: "circle")
                            Text(documentName).font(.caption)
                        }
                    }
                }
                .widgetBackground(Theme.redGradient.gradient)
                .padding(12)
                
                Spacer()
            }
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
                let lastThreeEntries: [String] = documentNames.suffix(3)
                let entry = Entry(date: Date(), documentNames: lastThreeEntries)
                completion(Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(3600))))
            }
        }
        
        func fetchDataFromFirebase(completion: @escaping ([String]) -> Void) {
            let db = Firestore.firestore()

            var arr: [String] = []

            db.collection("users").document("fcEziy2Qz7ONdyXCdqwVEefgOG02").collection("todos").getDocuments { (querySnapshot, error) in
                do {
                    if let error = error {
                        throw error
                    }

                    var itemsForToday: [String] {
                        let today = Calendar.current.startOfDay(for: Date()) // Data odierna
                        return querySnapshot!.documents.compactMap { document in
                            let data = document.data()
                            if let itemDateTimestamp = data["dueDate"] as? TimeInterval, let taskTitle = data["title"] as? String {
                                let itemDate = Date(timeIntervalSince1970: itemDateTimestamp) // Converti la data in un oggetto Date
                                if Calendar.current.isDate(itemDate, inSameDayAs: today) {
                                    return taskTitle // Restituisci solo il titolo dell'attività se è stata pubblicata oggi
                                }
                            }
                            return nil // Se l'oggetto non ha una data o non è di oggi, lo escludiamo
                        }
                    }

                    arr.append(contentsOf: itemsForToday)

                    completion(arr)
                } catch {
                    print("Errore nel recupero dei dati da Firebase: \(error)")
                    completion([])
                }
            }
        }


    }
}
