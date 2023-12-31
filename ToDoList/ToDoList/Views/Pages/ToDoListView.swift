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
    
    // PROGRESSBAR value items
    private var isDoneItemsForToday: [ToDoListItem] {
        itemsForToday.filter { itemIsDone in
            if itemIsDone.isDone == true {
                return itemIsDone.isDone
            }
            return itemIsDone.isDone
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
                
                ProgressBarView(valueBar: .constant(Double(isDoneItemsForToday.count)), totalValueBar: .constant(Double(itemsForToday.count)))
                
                List {
                    Section(header: Text("Today").font(.headline).foregroundColor(Color.blue)) {
                        ForEach(itemsForToday) { itemToday in
                            ToDoListItemView(
                                listItem: itemToday, fontSize: 18,
                                pomodoroIsClicked: $viewModel.isOpenPomodoroModel,
                                descriptionIsClicked: $viewModel.isOpenDescription)
                                .swipeActions {
                                    Button("Delete") {
                                        viewModel.delete(idItem: itemToday.id)
                                    }
                                    .tint(.red)
                                }
                                .sheet(isPresented: $viewModel.isOpenDescription) {
                                    NavigationStack {
                                        InfoToDoItemView(descriptionText: itemToday.description)
                                    }
                                }
                        }
                    }
                    .sheet(isPresented: $viewModel.isOpenPomodoroModel) {
                        NavigationStack {
                            PomodoroTimerView()
                        }
                    }
                    
                    Section(header: Text("Tomorrow").font(.headline)) {
                        ForEach(itemsForTomorrow) { itemTomorrow in
                            ToDoListItemView(
                                listItem: itemTomorrow, fontSize: 15,
                                pomodoroIsClicked: $viewModel.isOpenPomodoroModel,
                                descriptionIsClicked: $viewModel.isOpenDescription)
                                .swipeActions {
                                    Button("Delete") {
                                        viewModel.delete(idItem: itemTomorrow.id)
                                    }
                                    .tint(.red)
                                }
                                .sheet(isPresented: $viewModel.isOpenDescription) {
                                    NavigationStack {
                                        InfoToDoItemView(descriptionText: itemTomorrow.description)
                                    }
                                }
                        }
                    }
                    
                    Section(header: Text("After Tomorrow").font(.headline)) {
                        ForEach(itemsAfterTomorrow) { itemAfter in
                            ToDoListItemView(
                                listItem: itemAfter, fontSize: 15,
                                pomodoroIsClicked: $viewModel.isOpenPomodoroModel,
                                descriptionIsClicked: $viewModel.isOpenDescription)
                                .swipeActions {
                                    Button("Delete") {
                                        viewModel.delete(idItem: itemAfter.id)
                                    }
                                    .tint(.red)
                                }
                                .sheet(isPresented: $viewModel.isOpenDescription) {
                                    NavigationStack {
                                        InfoToDoItemView(descriptionText: itemAfter.description)
                                    }
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
