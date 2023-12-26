import SwiftUI

struct CalendarView: View {
    
    @Binding var dateSelected: Date
    
    var body: some View {
        DatePicker("Due date", selection: $dateSelected)
            .datePickerStyle(GraphicalDatePickerStyle())
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView(dateSelected: .constant(Date()))
    }
}
