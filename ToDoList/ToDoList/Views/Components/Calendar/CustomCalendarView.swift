import SwiftUI
import UIKit

struct CustomCalendarView: UIViewRepresentable {
    
    @ObservedObject var eventStore: CalendarViewViewModel
    @Binding var selectedDate: Date?
    @Binding var fetchItemsTask: [ToDoListItem]
    
    func makeUIView(context: Context) -> UICalendarView {
        let calendarView = UICalendarView()
        calendarView.delegate = context.coordinator
        // Configura la selezione della data
        let selectionBehavior = UICalendarSelectionSingleDate(delegate: context.coordinator as? UICalendarSelectionSingleDateDelegate)
        calendarView.selectionBehavior = selectionBehavior
        return calendarView
    }
    
    func updateUIView(_ uiView: UICalendarView, context: Context) {
        // Qui puoi aggiornare la view se necessario
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, eventStore: eventStore, itemTaskList: fetchItemsTask)
    }
    
    class Coordinator: NSObject, UICalendarViewDelegate {
        var parent: CustomCalendarView
        var eventStore: CalendarViewViewModel
        var fetchedTaskItems: [ToDoListItem]
        
        init(_ parent: CustomCalendarView, eventStore: CalendarViewViewModel, itemTaskList: [ToDoListItem]) {
            self.parent = parent
            self.eventStore = eventStore
            self.fetchedTaskItems = itemTaskList
        }
        
        func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
            let events = self.fetchedTaskItems.filter { item in
                let eventDate = Date(timeIntervalSince1970: item.dueDate)
                return Calendar.current.isDate(eventDate, equalTo: dateComponents.date!, toGranularity: .day)
            }
            if !events.isEmpty {
                // Sostituisci "dot" con il nome dell'immagine che vuoi usare o usa un'etichetta
                return .image(UIImage(named: "dot"), color: .systemRed, size: .small)
            } else {
                return nil
            }
        }
        
        func calendarView(_ calendarView: UICalendarView, didSelectDate dateComponents: DateComponents) {
            if let date = Calendar.current.date(from: dateComponents) {
                DispatchQueue.main.async {
                    self.parent.selectedDate = date
                }
            }
        }
    }
}


#Preview {
    CustomCalendarView(eventStore: CalendarViewViewModel(), selectedDate: .constant(Date()), fetchItemsTask: .constant([]))
}
