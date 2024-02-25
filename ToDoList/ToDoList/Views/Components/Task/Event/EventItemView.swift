import SwiftUI

struct EventItemView: View {
    
    @Binding var eventItem: EventItem
    
    var body: some View {
        let categoryColor = themeColorForCategory(category: eventItem.category)
                Circle()
                    .fill(categoryColor)
                    .cornerRadius(5.0)
                    .frame(width: 10 ,height: 20)
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
