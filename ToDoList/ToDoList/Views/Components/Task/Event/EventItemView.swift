import SwiftUI

struct EventItemView: View {
    
    @StateObject var viewModel = EventViewViewModel()
    @Binding var eventItem: EventItem
    
    var body: some View {
        let categoryColor = themeColorForCategory(category: eventItem.category)
        
        if viewModel.isSameDay(date1: eventItem.startDate, date2: eventItem.endDate) {
            Circle()
                .fill(eventItem.category == .none ? Color.primary : categoryColor)
                .cornerRadius(5.0)
                .frame(width: 11.5 ,height: 11.5)
        } else {
            Image(systemName: "circle.circle")
                .font(.system(size: 11.5))
                .foregroundColor(Color.clear)
                .background(eventItem.category == .none ? Color.primary : categoryColor)
                .mask(Image(systemName: "circle.circle").font(.system(size: 11.5)))
        }
    }

}

struct EventItem_Preview: PreviewProvider {
    static var previews: some View {
        EventItemView(
            eventItem: .constant(
                EventItem(
                    id: "12345678",
                    title: "titolo",
                    startDate: Date().timeIntervalSince1970,
                    endDate: Date().timeIntervalSince1970,
                    createdDate: Date().timeIntervalSince1970,
                    category: .home,
                    description: InfoToDoItem(
                        id: "12345678",
                        description: "Description"))
            )
        )
        .previewLayout(.sizeThatFits)
    }
}
