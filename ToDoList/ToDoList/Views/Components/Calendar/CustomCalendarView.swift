import SwiftUI
import UIKit

struct CustomCalendarView: UIViewRepresentable {
    
    @ObservedObject var eventStore: CalendarViewViewModel
    @Binding var selectedDate: Date?
    @Binding var fetchItemsTask: [ToDoListItem]
    @Binding var fetchEventItems: [EventItem] /// ! non utilizzato -> fai apparire un segnalino i giorni con evento
    var scale: CGFloat
    
    func makeUIView(context: Context) -> UICalendarView {
        let calendarView = UICalendarView()
        calendarView.delegate = context.coordinator
        // Configura la selezione della data
        let selectionBehavior = UICalendarSelectionSingleDate(delegate: context.coordinator)
        calendarView.selectionBehavior = selectionBehavior
        calendarView.transform = CGAffineTransform(scaleX: scale, y: scale)
        return calendarView
    }
    
    func updateUIView(_ uiView: UICalendarView, context: Context) {
        // Aggiorna la vista se necessario, ad esempio impostando la data selezionata sul calendario.
        uiView.transform = CGAffineTransform(scaleX: scale, y: scale)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
        var parent: CustomCalendarView
        
        init(_ parent: CustomCalendarView) {
            self.parent = parent
        }
        
        func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
            
            let today = Calendar.current.startOfDay(for: Date()) // Ottiene l'inizio della giornata corrente
            let eventDate = Calendar.current.date(from: dateComponents) ?? Date()
            
            let events = self.parent.fetchItemsTask.filter { item in
                let eventDate = Date(timeIntervalSince1970: item.dueDate)
                return Calendar.current.isDate(eventDate, equalTo: dateComponents.date!, toGranularity: .day)
            }
            if !events.isEmpty {
                if eventDate < today {
                    /// Se l'evento è prima di oggi, usa il colore grigio
                    return .image(UIImage(named: "dot"), color: .gray, size: .small)
                } else {
                    /// Se l'evento è oggi o in futuro, usa il colore rosso
                    return .image(UIImage(named: "dot"), color: .systemRed, size: .small)
                }
            } else {
                return nil
            }
        }
        
        // Conforme al protocollo UICalendarSelectionSingleDateDelegate
        func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
            if let dateComponents = dateComponents, let date = Calendar.current.date(from: dateComponents) {
                DispatchQueue.main.async {
                    self.parent.selectedDate = date
                }
            }
        }
    }
}

// Preview
struct CustomCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CustomCalendarView(
            eventStore: CalendarViewViewModel(),
            selectedDate: .constant(Date()),
            fetchItemsTask: .constant([]),
            fetchEventItems: .constant([]),
            scale: 0.75)
    }
}
