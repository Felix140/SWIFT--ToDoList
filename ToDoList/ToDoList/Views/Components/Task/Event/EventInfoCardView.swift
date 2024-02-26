import SwiftUI

struct EventInfoCardView: View {
    
    let eventItem: EventItem
    @StateObject var viewModel = EventViewViewModel()
    
    var body: some View {
        
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    if eventItem.category != .none {
                        Text(eventItem.category.categoryName)
                            .font(.caption)
                    }
                    Text(eventItem.title)
                        .foregroundStyle(.primary)
                        .font(.system(size: 18))
                        .fontWeight(.semibold)
                }
                
                Spacer()
                Divider()
                
                if viewModel.isSameDay(date1: eventItem.startDate, date2: eventItem.endDate){
                    VStack(alignment: .leading) {
                        Text("\(Date(timeIntervalSince1970: eventItem.startDate).formatted(.dateTime.day(.twoDigits).month()))")
                            .foregroundStyle(.primary)
                            .bold()
                    }
                } else {
                    VStack(alignment: .leading) {
                        Text("\(Date(timeIntervalSince1970: eventItem.startDate).formatted(.dateTime.day(.twoDigits).month()))")
                            .foregroundStyle(.primary)
                            .bold()
                        Text("\(Date(timeIntervalSince1970: eventItem.endDate).formatted(.dateTime.day(.twoDigits).month()))")
                            .foregroundStyle(.primary)
                            .bold()
                    }
                }
                
                Spacer()
                    .frame(width: 20)
                
                if viewModel.isSameDay(date1: eventItem.startDate, date2: eventItem.endDate) {
                    Circle()
                        .fill(.primary)
                        .cornerRadius(5.0)
                        .frame(width: 8 ,height: 8)
                } else {
                    Image(systemName: "circle.circle")
                        .font(.system(size: 8))
                        .foregroundColor(.primary)
                }
            }
            .padding(.vertical)
            
            if eventItem.description.description != "" {
                description(text: eventItem.description.description)
            }
        }
    }

    //MARK: - Description
    
    @ViewBuilder
    func description(text: String) -> some View {
        DisclosureGroup("") {
            HStack {
                Image(systemName: "info.circle")
                    .font(.callout)
                Text(text)
                    .font(.subheadline)
                    .padding()
            }
            .padding(.leading, 4)
        }
        .font(.caption2)
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
