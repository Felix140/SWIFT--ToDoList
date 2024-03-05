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
                .onLongPressGesture(minimumDuration: 0.1) {
                    withAnimation(.default) {
                        self.haptic.feedbackLight()
                        self.eventToEdit = item /// Aggiorna itemToEdit con l'elemento corrente
                        viewModel.onOpenEditButtons(item: item)
                        print("Modale aperta in attivazione")
                    }
                }
                .listRowBackground(themeColorForCategory(category: item.category))
                
            }
            .actionSheet(isPresented: $viewModel.showingEditButtons) {
                ActionSheet(title: Text("Actions selection"), buttons: [
                    .default(Text("Edit Event")) {
                        viewModel.isOpenEditModal = true
                        haptic.feedbackLight()
                    },
                    .destructive(Text("Delete Event")) {
                        viewModel.deleteEventItem()
                        haptic.feedbackLight()
                    },
                    .cancel()
                ])
            }
        }
        .sheet(isPresented: $viewModel.isOpenEditModal) {
            if let item = eventToEdit {
                NavigationStack {
                    EditEventItemView(itemToSet: .constant(item), viewModelEdit: viewModel)
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
