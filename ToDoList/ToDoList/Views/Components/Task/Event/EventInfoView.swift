import SwiftUI

struct EventInfoView: View {
    
    @Binding var eventListItem: [EventItem]
    
    var body: some View {
        List {
            ForEach(eventListItem) { item in
                Section {
                    EventInfoCardView(eventItem: item)
                        .background(themeColorForCategory(category: item.category))
                }
                .listRowBackground(themeColorForCategory(category: item.category))
            }
        }
    }
}

struct EventInfoView_Preview: PreviewProvider {
    static var previews: some View {
        EventInfoView(eventListItem: .constant([]))
    }
}
