import SwiftUI

struct CalendarView: View {
    
    @Binding var dateSelected: Date
    
    var body: some View {
        VStack {
            DatePicker("Due date", selection: $dateSelected)
                .datePickerStyle(GraphicalDatePickerStyle())
        }
        .padding([.leading, .trailing], 25)
    }
    
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView(dateSelected: .constant(Date()))
    }
}
