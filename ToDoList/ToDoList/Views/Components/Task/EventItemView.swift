import SwiftUI

struct EventItemView: View {
    
    @Binding var eventItem: EventItem
    
    var body: some View {
        Button(action: {
            
        }, label: {
            
            let categoryColor = themeColorForCategory(category: eventItem.category)
            ZStack {
                Rectangle()
                    .fill(categoryColor)
                    .cornerRadius(5.0)
                    .frame(height: 18)
                
                HStack {
                    Text(eventItem.title)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        .padding(.leading, 50)
                    Spacer()
                }
                
            }
            .padding(.horizontal)
            
        })

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
    }
}
