import Foundation
import FirebaseFirestoreSwift

class ToDoItemViewViewModel: ObservableObject {
    
    @FirestoreQuery var fetchedItems: [ToDoListItem]
    @Published var selectByDate: Date? = nil /// Valore di partenza per visualizzare taskListAll()
    
    // TOMORROW items
    var itemsForTomorrow: [ToDoListItem] {
        fetchedItems.filter { item in
            let itemDate = Date(timeIntervalSince1970: item.dueDate) /// converto to Date
            return Calendar.current.isDateInTomorrow(itemDate)
        }
        .sorted(by: { $0.dueDate < $1.dueDate }) /// ordina per orario
    }
    
    // AFTER TOMORROW items
    var itemsAfterTomorrow: [ToDoListItem] {
        fetchedItems.filter { item in
            let calendar = Calendar.current
            // Ottieni l'inizio del giorno dopo domani
            let dayAfterTomorrow = calendar.date(byAdding: .day, value: 2, to: calendar.startOfDay(for: Date()))!
            let itemDate = Date(timeIntervalSince1970: item.dueDate)
            return itemDate >= dayAfterTomorrow
        }
        .sorted(by: { $0.dueDate < $1.dueDate }) /// Li ordino dal giorno più recente al più lontano
    }
    
    // Filter Task by Date selected
    private var filteredItemsBySelectedDate: [ToDoListItem] {
        fetchedItems.filter { item in
            let itemDate = Date(timeIntervalSince1970: item.dueDate)
            let calendar = Calendar.current
            return calendar.isDate(itemDate, inSameDayAs: selectByDate ?? Date() )
        }
    }
    
    init(userId: String) {
        /// users/<id>/todos/<entries>
        self._fetchedItems = FirestoreQuery(collectionPath: "users/\(userId)/todos/") // GET query
    }
    
}
