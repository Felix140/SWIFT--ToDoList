import SwiftUI
import FirebaseFirestoreSwift
import WidgetKit

struct ToDoListView: View {
    
    /// @StateObject var viewModel = ToDoListViewViewModel()
    /// anziche creare uno StateObject come qui sopra, inizializziamo l'oggetto in init() per
    /// passargli il parametro dello userId, inizializzato a sua volta nell'init() di "ToDoListViewViewModel()"
    @StateObject var viewModel: ToDoListViewViewModel
    @FirestoreQuery var fetchedItems: [ToDoListItem]
    private var haptic = HapticTrigger()
    @State private var selectedPicker = 0
    
    // TODAY items
    private var itemsForToday: [ToDoListItem] {
        fetchedItems.filter { item in
            let itemDate = Date(timeIntervalSince1970: item.dueDate) /// convert to Date
            if Bundle.main.bundleIdentifier != nil {
                WidgetCenter.shared.reloadTimelines(ofKind: "TooDooWidget")
            }
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
            collectionPath: "users/\(userId)/todos/") // GET query
        
        /// inizializzo qui sotto viewModel come StateObject
        self._viewModel = StateObject(wrappedValue: ToDoListViewViewModel(userId: userId))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                
                ProgressBarView(
                    valueBar: Double(isDoneItemsForToday.count),
                    totalValueBar: Double(itemsForToday.count))
                
                HStack {
                    if #available(iOS 17.0, *) {
                        Picker("TooDoo List", selection: $selectedPicker) {
                            Text("All Task").tag(0)
                            Text("To Do").tag(1)
                            Text("Done").tag(2)
                        }
                        .pickerStyle(.palette)
                    } else {
                        
                        Picker("TooDoo List", selection: $selectedPicker) {
                            Text("All Task").tag(0)
                            Text("To Do").tag(1)
                            Text("Done").tag(2)
                        }
                        .pickerStyle(.segmented)
                    }
                    
                }
                .padding(.horizontal, 10)
                
                
                switch selectedPicker {
                case 0: taskListAll()  // TASK LIST ALL
                case 1: filterToDoList() // TODO LIST
                case 2: filterDoneList() // DONE LIST
                default:
                    Text("ERROR: Informations not available")
                }
                
            }
            .navigationTitle("TooDoo List")
            .toolbar{
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: {
                        self.haptic.feedbackMedium()
                        viewModel.isPresentingView = true
                        if Bundle.main.bundleIdentifier != nil {
                            WidgetCenter.shared.reloadTimelines(ofKind: "TooDooWidget")
                        }
                    }) {
                        Image(systemName: "plus.circle")
                    }
                    .accessibilityLabel("Add new Item")
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        self.haptic.feedbackMedium()
                        // Select All Items (Picker)
                    }) {
                        Image(systemName: "ellipsis")
                    }
                    .accessibilityLabel("Edit Item")
                }
            }
            .onAppear {
                if Bundle.main.bundleIdentifier != nil {
                    WidgetCenter.shared.reloadTimelines(ofKind: "TooDooWidget")
                }
            }
            
        }
        .sheet(isPresented: $viewModel.isPresentingView) {
            NavigationStack {
                NewItemView(
                    toggleView: $viewModel.isPresentingView
                )
            }
        }
    }
    
    @ViewBuilder
    func taskListAll() -> some View {
        
        List {
            Section(header: Text("Today").font(.headline).foregroundColor(Color.blue)) {
                ForEach(itemsForToday) { itemToday in
                    ToDoListItemView(
                        listItem: itemToday, fontSize: 18,
                        descriptionIsClicked: $viewModel.isOpenDescription)
                    .sheet(isPresented: $viewModel.isOpenDescription) {
                        NavigationStack {
                            InfoToDoItemView(descriptionText: itemToday.description.description)
                        }
                    }
                }
                .onDelete { indexSet in
                    withAnimation {
                        // Esegui l'eliminazione degli elementi qui, avvolta da withAnimation
                        for index in indexSet {
                            self.haptic.feedbackLight()
                            viewModel.delete(idItem: itemsForToday[index].id)
                        }
                    }
                }
            }
            
            
            Section(header: Text("Tomorrow").font(.headline)) {
                ForEach(itemsForTomorrow) { itemTomorrow in
                    ToDoListItemView(
                        listItem: itemTomorrow, fontSize: 15,
                        descriptionIsClicked: $viewModel.isOpenDescription)
                    .sheet(isPresented: $viewModel.isOpenDescription) {
                        NavigationStack {
                            InfoToDoItemView(descriptionText: itemTomorrow.description.description)
                        }
                    }
                }
                .onDelete { indexSet in
                    withAnimation {
                        // Esegui l'eliminazione degli elementi qui, avvolta da withAnimation
                        for index in indexSet {
                            self.haptic.feedbackLight()
                            viewModel.delete(idItem: itemsForTomorrow[index].id)
                        }
                    }
                }
            }
            
            Section(header: Text("After Tomorrow").font(.headline)) {
                ForEach(itemsAfterTomorrow) { itemAfter in
                    ToDoListItemView(
                        listItem: itemAfter, fontSize: 15,
                        descriptionIsClicked: $viewModel.isOpenDescription)
                    .sheet(isPresented: $viewModel.isOpenDescription) {
                        NavigationStack {
                            InfoToDoItemView(descriptionText: itemAfter.description.description)
                        }
                    }
                }
                .onDelete { indexSet in
                    withAnimation {
                        // Esegui l'eliminazione degli elementi qui, avvolta da withAnimation
                        for index in indexSet {
                            self.haptic.feedbackLight()
                            viewModel.delete(idItem: itemsAfterTomorrow[index].id)
                        }
                    }
                }
            }
        }
        .listStyle(PlainListStyle())
    }
    
    @ViewBuilder
    func filterToDoList() -> some View {
        List {
            Section(header: Text("Today").font(.headline).foregroundColor(Color.blue)) {
                ForEach(itemsForToday) { itemToday in
                    if !itemToday.isDone {
                        ToDoListItemView(
                            listItem: itemToday, fontSize: 18,
                            descriptionIsClicked: $viewModel.isOpenDescription)
                        .swipeActions {
                            Button("Edit") {
                                /// modifica SE la task è stata creata da te
                            }
                            .tint(.blue)
                        }
                        .sheet(isPresented: $viewModel.isOpenDescription) {
                            NavigationStack {
                                InfoToDoItemView(descriptionText: itemToday.description.description)
                            }
                        }
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
    
    @ViewBuilder
    func filterDoneList() -> some View {
        List {
            Section(header: Text("Today").font(.headline).foregroundColor(Color.blue)) {
                ForEach(itemsForToday) { itemToday in
                    if itemToday.isDone {
                        ToDoListItemView(
                            listItem: itemToday, fontSize: 18,
                            descriptionIsClicked: $viewModel.isOpenDescription)
                        .sheet(isPresented: $viewModel.isOpenDescription) {
                            NavigationStack {
                                InfoToDoItemView(descriptionText: itemToday.description.description)
                            }
                        }
                    }
                }
                .onDelete { indexSet in
                    withAnimation {
                        // Esegui l'eliminazione degli elementi qui, avvolta da withAnimation
                        for index in indexSet {
                            self.haptic.feedbackLight()
                            viewModel.delete(idItem: itemsForToday[index].id)
                        }
                    }
                }
            }
            .onAppear {
                if Bundle.main.bundleIdentifier != nil {
                    WidgetCenter.shared.reloadTimelines(ofKind: "TooDooWidget")
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
}

struct ToDoListView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoListView(userId: "dK6CG6dD7vUwHggvLO2jjTauQGA3")
    }
}
