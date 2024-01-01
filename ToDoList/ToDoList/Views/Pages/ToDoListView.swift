import SwiftUI
import FirebaseFirestoreSwift

struct ToDoListView: View {
    
    /// @StateObject var viewModel = ToDoListViewViewModel()
    /// anziche creare uno StateObject come qui sopra, inizializziamo l'oggetto in init() per
    /// passargli il parametro dello userId, inizializzato a sua volta nell'init() di "ToDoListViewViewModel()"
    @StateObject var viewModel: ToDoListViewViewModel
    @FirestoreQuery var fetchedItems: [ToDoListItem]
    
    // TODAY items
    private var itemsForToday: [ToDoListItem] {
        fetchedItems.filter { item in
            let itemDate = Date(timeIntervalSince1970: item.dueDate) /// convert to Date
            return Calendar.current.isDateInToday(itemDate)
        }
    }
    
    // TOMORROW items
    private var itemsForTomorrow: [ToDoListItem] {
        fetchedItems.filter { item in
            let itemDate = Date(timeIntervalSince1970: item.dueDate) /// converto to Date
            return Calendar.current.isDateInTomorrow(itemDate)
        }
    }
    
    // AFTER TOMORROW items
    private var itemsAfterTomorrow: [ToDoListItem] {
        fetchedItems.filter { item in
            let calendar = Calendar.current
            // Ottieni l'inizio del giorno dopo domani
            let dayAfterTomorrow = calendar.date(byAdding: .day, value: 2, to: calendar.startOfDay(for: Date()))!
            let itemDate = Date(timeIntervalSince1970: item.dueDate)
            return itemDate >= dayAfterTomorrow
        }
    }
    
    init(userId: String) {
        
        /// users/<id>/todos/<entries>
        self._fetchedItems = FirestoreQuery(
            collectionPath: "users/\(userId)/ToDos/") // GET query
        
        /// inizializzo qui sotto viewModel come StateObject
        self._viewModel = StateObject(wrappedValue: ToDoListViewViewModel(userId: userId))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                ProgressBarView(valueBar: .constant(0.6))
                List {
                    Section(header: Text("Today").font(.headline).foregroundColor(Color.blue)) {
                        ForEach(itemsForToday) { item in
                            ToDoListItemView(
                                listItem: item, fontSize: 20,
                                pomodoroIsClicked: $viewModel.isOpenPomodoroModel)
                                .swipeActions {
                                    Button("Delete") {
                                        viewModel.delete(idItem: item.id)
                                    }
                                    .tint(.red)
                                }
                        }
                    }
                    .sheet(isPresented: $viewModel.isOpenPomodoroModel) {
                        NavigationStack {
                            PomodoroTimerView()
                        }
                    }
                    
                    Section(header: Text("Tomorrow").font(.headline)) {
                        ForEach(itemsForTomorrow) { item in
                            ToDoListItemView(
                                listItem: item, fontSize: 15,
                                pomodoroIsClicked: $viewModel.isOpenPomodoroModel)
                                .swipeActions {
                                    Button("Delete") {
                                        viewModel.delete(idItem: item.id)
                                    }
                                    .tint(.red)
                                }
                        }
                    }
                    
                    Section(header: Text("After Tomorrow").font(.headline)) {
                        ForEach(itemsAfterTomorrow) { item in
                            ToDoListItemView(
                                listItem: item, fontSize: 15,
                                pomodoroIsClicked: $viewModel.isOpenPomodoroModel)
                                .swipeActions {
                                    Button("Delete") {
                                        viewModel.delete(idItem: item.id)
                                    }
                                    .tint(.red)
                                }
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("TooDoo List")
            .toolbar{
                Button(action: {
                    viewModel.isPresentingView = true
                }) {
                    Image(systemName: "plus")
                }
                .accessibilityLabel("Add new Item")
            }
        }
        .sheet(isPresented: $viewModel.isPresentingView) {
            NavigationStack {
                NewItemView(
                    toggleView: $viewModel.isPresentingView,
                    isOnPomodoro: $viewModel.isOnPomodoro)
            }
        }
    }
}

struct ToDoListView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoListView(userId: "dK6CG6dD7vUwHggvLO2jjTauQGA3")
    }
}
