import Foundation


class CalendarViewViewModel: ObservableObject {
    @Published var events: [ToDoListItem] = []

    init(events: [ToDoListItem] = []) {
        self.events = events
    }
}
