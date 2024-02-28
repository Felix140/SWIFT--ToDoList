import Foundation
import FirebaseFirestoreSwift


class EventItemViewViewModel: ObservableObject {
    
    @FirestoreQuery var fetchedEventitems: [EventItem]
    @Published var selectByDate: Date? = nil /// Valore di partenza per visualizzare taskListAll()
    
    // EVENTS for TODAY items
    private var eventsForToday: [EventItem] {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)
        
        return fetchedEventitems.filter { eventItem in
            let startDate = Date(timeIntervalSince1970: eventItem.startDate)
            let endDate = Date(timeIntervalSince1970: eventItem.endDate)
            // Verifica che l'evento inizi prima della fine del giorno e finisca dopo l'inizio del giorno
            return startDate < endOfDay! && endDate >= startOfDay
        }
    }
    
    // EVENTS for TOMORROW items
    private var eventsForTomorrow: [EventItem] {
        let calendar = Calendar.current
        /// inizio del giorno successivo
        guard let startOfTomorrow = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: Date())) else {
            return []
        }
        /// Calcola l'inizio del giorno dopo il giorno successivo
        guard let startOfTheDayAfterTomorrow = calendar.date(byAdding: .day, value: 1, to: startOfTomorrow) else {
            return []
        }
        
        return fetchedEventitems.filter { eventItem in
            let startDate = Date(timeIntervalSince1970: eventItem.startDate)
            let endDate = Date(timeIntervalSince1970: eventItem.endDate)
            /// Verifica che l'evento inizi in qualsiasi momento durante il giorno successivo
            /// e che l'evento finisca dopo l'inizio del giorno successivo
            return (startDate >= startOfTomorrow && startDate < startOfTheDayAfterTomorrow) || (endDate > startOfTomorrow && startDate < startOfTheDayAfterTomorrow)
        }
    }
    
    // Filter Event by Date selected
    private var filteredEventsBySelectedDate: [EventItem] {
        fetchedEventitems.filter { event in
            let eventStartDate = Date(timeIntervalSince1970: event.startDate)
            let eventEndDate = Date(timeIntervalSince1970: event.endDate)
            guard let selectedDate = selectByDate else { return false }
            let calendar = Calendar.current
            let startOfDay = calendar.startOfDay(for: selectedDate)
            let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
            /// L'evento è incluso se inizia prima della fine del giorno selezionato e finisce dopo l'inizio del giorno selezionato
            return eventStartDate < endOfDay && eventEndDate >= startOfDay
        }
    }
    
    init(userId: String) {
        /// users/<id>/events/<entries>
        self._fetchedEventitems = FirestoreQuery(collectionPath: "users/\(userId)/events/")
    }
    
}
