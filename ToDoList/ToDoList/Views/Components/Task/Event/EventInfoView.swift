import SwiftUI

struct EventInfoView: View {
    
    @StateObject var viewModel = EventViewViewModel()
    @Binding var eventListItem: [EventItem]
    @State private var eventToEdit: EventItem?
    var haptic = HapticTrigger()
    
    var body: some View {
        List {
            ForEach(eventListItem) { item in
                Section {
                    EventInfoCardView(eventItem: item)
                        .background(themeColorForCategory(category: item.category))
                }
                .listRowBackground(themeColorForCategory(category: item.category))
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    // Delete
                    Button {
                        viewModel.deleteEvent(event: item)
                        haptic.feedbackLight()
                    } label: {
                        Image(systemName: "trash")
                    }
                    .tint(themeColorForCategory(category: item.category))
                    // Edit
                    Button {
                        self.eventToEdit = nil
                        self.eventToEdit = item
                        viewModel.isOpenEditModal = true
                        haptic.feedbackLight()
                    } label: {
                        Image(systemName: "pencil")
                    }
                    .tint(themeColorForCategory(category: item.category))
                }
                .sheet(isPresented: $viewModel.isOpenEditModal) {
                    if let item = eventToEdit {
                        NavigationStack {
                            EditEventItemView(itemToSet: .constant(item), viewModelEdit: viewModel)
                        }
                    }
                }
            }
        }
        .navigationTitle("Events")
    }
}

struct EventInfoView_Preview: PreviewProvider {
    static var previews: some View {
        EventInfoView(eventListItem: .constant([
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
        ]))
    }
}
