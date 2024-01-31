import SwiftUI
import WidgetKit
import Intents
import Firebase

struct ToDoItemsWidget: Widget {
    private let kind = "TooDooWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            EntryView(entry: entry)
        }
        .configurationDisplayName("TooDoo Widget")
        .description("See your tasks.")
        .supportedFamilies([.systemMedium])
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

// MARK: - WIDGET VIEW

extension ToDoItemsWidget {
    struct EntryView: View {
        
        let entry: Entry
        
        var body: some View {
            
            VStack(alignment: .leading, spacing: 8) {
                
                Spacer()
                
                
                HStack {
                    Image(systemName: "calendar.circle.fill")
                        .font(.system(size: 30))
                    Text("Today")
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Spacer()
                }
                
                
                
                ForEach(entry.documentNames, id: \.self) { documentName in
                    HStack {
                        Spacer()
                            .frame(width: 10)
                        Image(systemName: "circle.bottomrighthalf.checkered")
                        Spacer()
                            .frame(width: 18)
                        Text(documentName)
                            .font(.system(size: 14))
                    }
                }
                
                Spacer()
                
                
            }
            .widgetBackground(Theme.redGradient.gradient)
            .padding(.horizontal, 4)
            .padding(.vertical, 14)
            
            
            
        }
    }
}

extension View {
    func widgetBackground(_ backgroundView: some View) -> some View {
        if #available(iOS 17.0, *) {
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
                let lastThreeEntries: [String] = documentNames.suffix(4) // print number of entries(TASKS)
                let entry = Entry(date: Date(), documentNames: lastThreeEntries)
                completion(Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(3600))))
            }
        }
        
        func fetchDataFromFirebase(completion: @escaping ([String]) -> Void) {
            let db = Firestore.firestore()
            
            var arr: [String] = []
            
            //            guard let currentUserID = Auth.auth().currentUser?.uid else {
            //                print("Utente non valido per il fetch db widget: \(String(describing: Auth.auth().currentUser))")
            //                completion(["Please Login"])
            //                return
            //            }
            let defaults = UserDefaults(suiteName: "group.com.felixvaldez.ToDoList")
            guard let userId = defaults?.string(forKey: "currentUserIdKey") else {
                print("Utente non valido per il fetch db widget: \(String(describing: Auth.auth().currentUser))")
                return
            }
            
            let fetchTodos = db.collection("users").document(userId).collection("todos")
            
            fetchTodos.getDocuments { (querySnapshot, error) in
                do {
                    if let error = error {
                        throw error
                    }
                    
                    var itemsForToday: [String] {
                        
                        let today = Calendar.current.startOfDay(for: Date()) // Data odierna
                        return querySnapshot!.documents.compactMap { document in
                            let data = document.data()
                            if let itemDateTimestamp = data["dueDate"] as? TimeInterval,
                               let taskTitle = data["title"] as? String,
                               let isDone = data["isDone"] as? Bool,
                               !isDone {  // Filtra solo le attività non completate
                                let itemDate = Date(timeIntervalSince1970: itemDateTimestamp)
                                if Calendar.current.isDate(itemDate, inSameDayAs: today) {
                                    return taskTitle // Restituisci il titolo dell'attività se è di oggi e non completata
                                }
                            }
                            return nil // Se l'oggetto non ha una data o non è di oggi, lo escludiamo
                        }
                    }
                    
                    arr.append(contentsOf: itemsForToday)
                    completion(arr)
                    
                } catch {
                    print("Errore nel recupero dei dati da Firebase: \(error)")
                    print(error.localizedDescription)
                    completion([])
                }
            }
        }
    }
}
