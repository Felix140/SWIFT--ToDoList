import SwiftUI

struct EventInfoCardView: View {
    
    let eventItem: EventItem
    
    var body: some View {
        
        HStack {
            VStack(alignment: .leading) {
                Text(eventItem.title)
                    .foregroundStyle(.primary)
                HStack {
                    Text(eventItem.category.categoryName)
                        .foregroundStyle(.primary)
                }
            }
            
            Spacer()
            Divider()

            VStack(alignment: .leading) {
                Text("\(Date(timeIntervalSince1970: eventItem.startDate).formatted(.dateTime.day(.twoDigits).month()))")
                    .foregroundStyle(.primary)
                    .bold()
                Text("\(Date(timeIntervalSince1970: eventItem.endDate).formatted(.dateTime.day(.twoDigits).month()))")
                    .foregroundStyle(.primary)
                    .bold()
            }
        }
    }
}

struct EventInfoCardView_Preview: PreviewProvider {
    static var previews: some View {
        EventInfoCardView(
            eventItem: EventItem(
                id: "12345678",
                title: "titolo",
                startDate: Date().timeIntervalSince1970,
                endDate: Date().timeIntervalSince1970,
                createdDate: Date().timeIntervalSince1970,
                category: .home,
                description: InfoToDoItem(
                    id: "12345678",
                    description: "Description")
            )
        )
    }
}
