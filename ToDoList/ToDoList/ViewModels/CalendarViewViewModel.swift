import Foundation


class CalendarViewViewModel: ObservableObject {
    @Published var events: [ToDoListItem] = []

    // Inizializzazione con eventi di esempio o caricamento da una fonte
    init(events: [ToDoListItem] = []) {
        self.events = events
        // Qui puoi caricare gli eventi dal tuo database o Firestore
    }
}
