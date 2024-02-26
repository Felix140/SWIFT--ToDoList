import SwiftUI

struct EventInfoCardView: View {
    
    let eventItem: EventItem
    
    var body: some View {
        
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(eventItem.category.categoryName)
                        .font(.caption)
                    Text(eventItem.title)
                        .foregroundStyle(.primary)
                        .font(.title2)
                }
                
                Spacer()
                Divider()
                
                if isSameDay(date1: eventItem.startDate, date2: eventItem.endDate){
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
            }
            
            if eventItem.description.description != "" {
                description(text: eventItem.description.description)
            }
        }
    }
    
    private func isSameDay(date1: TimeInterval, date2: TimeInterval) -> Bool { ///    Check start e end sono uguali
        let calendar = Calendar.current
        let date1 = Date(timeIntervalSince1970: date1)
        let date2 = Date(timeIntervalSince1970: date2)
        let day1 = calendar.component(.day, from: date1)
        let month1 = calendar.component(.month, from: date1)
        let year1 = calendar.component(.year, from: date1)
        let day2 = calendar.component(.day, from: date2)
        let month2 = calendar.component(.month, from: date2)
        let year2 = calendar.component(.year, from: date2)
        return day1 == day2 && month1 == month2 && year1 == year2
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
