import SwiftUI

struct EventInfoView: View {
    
    @StateObject var viewModel = EventViewViewModel()
    @Binding var eventListItem: [EventItem]
    var haptic = HapticTrigger()
    
    var body: some View {
        List {
            ForEach(eventListItem) { item in
                Section {
                    EventInfoCardView(eventItem: item)
                        .background(themeColorForCategory(category: item.category))
                }
                .listRowBackground(themeColorForCategory(category: item.category))
            }
            .onDelete { indexSet in
                withAnimation {
                    for index in indexSet {
                        self.haptic.feedbackLight()
                        viewModel.deleteEvent(event: eventListItem[index])
                    }
                }
            }
        }
    }
}

struct EventInfoView_Preview: PreviewProvider {
    static var previews: some View {
        EventInfoView(eventListItem: .constant([]))
    }
}
