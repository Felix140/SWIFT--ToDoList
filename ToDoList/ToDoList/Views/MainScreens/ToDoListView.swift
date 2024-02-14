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
    
    //MARK: - Body
    
    var body: some View {
        NavigationView {
            VStack {
                
                ProgressBarView(
                    valueBar: Double(isDoneItemsForToday.count),
                    totalValueBar: Double(itemsForToday.count))
                
                
                CustomPickerView(selectedPicker: $selectedPicker)
                
                
                // Carosello
                TabView(selection: $selectedPicker) {
                    taskListAll()
                        .tag(0)
                    filterToDoList()
                        .tag(1)
                    filterDoneList()
                        .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                Spacer()
                
                
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
                        Image(systemName: "plus.app")
                            .font(.system(size: 25))
                            .foregroundColor(Color.clear) /// Make the original icon transparent
                            .background(Theme.red.gradient) /// Apply the gradient as background
                            .mask(Image(systemName: "plus.app").font(.system(size: 23))) /// generate a mask
                    }
                    .accessibilityLabel("Add New Task")
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
    
    //MARK: - TaskListAll
    
    @ViewBuilder
    func taskListAll() -> some View {
        
        List {
            Section(header: Text("Today").font(.headline).foregroundColor(Color.blue)) {
                ForEach(itemsForToday) { itemToday in
                    VStack {
                        ToDoListItemView(
                            listItem: itemToday, fontSize: 17)
                        .onLongPressGesture {
                            withAnimation(.default) {
                                self.haptic.feedbackLight()
                                viewModel.promptForDeleteConfirmation(item: itemToday)
                            }
                        }
                        
                        if itemToday.description.description != "" {
                            description(text: itemToday.description.description)
                        }
                    }
                }
                .actionSheet(isPresented: $viewModel.showingDeleteConfirmation) {
                    ActionSheet(title: Text("Seleziona un azione"), buttons: [
                        .default(Text("Vedi Dettagli")) {
                            viewModel.isOpenDescription = true
                        },
                        .default(Text("Modifica")) {
                            viewModel.modifyTask()
                        },
                        .destructive(Text("Elimina")) {
                            viewModel.confirmAndDelete()
                        },
                        .cancel()
                    ])
                }
            }
            
            
            Section(header: Text("Tomorrow").font(.headline)) {
                ForEach(itemsForTomorrow) { itemTomorrow in
                    VStack {
                        ToDoListItemView(
                            listItem: itemTomorrow, fontSize: 15)
                        .onLongPressGesture {
                            withAnimation(.default) {
                                self.haptic.feedbackLight()
                                viewModel.promptForDeleteConfirmation(item: itemTomorrow)
                            }
                        }
                        
                        if itemTomorrow.description.description != "" {
                            description(text: itemTomorrow.description.description)
                        }
                    }
                }
                .actionSheet(isPresented: $viewModel.showingDeleteConfirmation) {
                    ActionSheet(title: Text("Seleziona un azione"), buttons: [
                        .default(Text("Modifica")) {
                            viewModel.modifyTask()
                        },
                        .destructive(Text("Elimina")) {
                            viewModel.confirmAndDelete()
                        },
                        .cancel()
                    ])
                }
            }
            
            Section(header: Text("After Tomorrow").font(.headline)) {
                ForEach(itemsAfterTomorrow) { itemAfter in
                    VStack {
                        ToDoListItemView(
                            listItem: itemAfter, fontSize: 15)
                        .onLongPressGesture {
                            withAnimation(.default) {
                                self.haptic.feedbackLight()
                                viewModel.promptForDeleteConfirmation(item: itemAfter)
                            }
                        }
                        
                        if itemAfter.description.description != "" {
                            description(text: itemAfter.description.description)
                        }
                    }
                }
                .actionSheet(isPresented: $viewModel.showingDeleteConfirmation) {
                    ActionSheet(title: Text("Seleziona un azione"), buttons: [
                        .default(Text("Vedi Dettagli")) {
                            viewModel.isOpenDescription = true
                        },
                        .default(Text("Modifica")) {
                            viewModel.modifyTask()
                        },
                        .destructive(Text("Elimina")) {
                            viewModel.confirmAndDelete()
                        },
                        .cancel()
                    ])
                }
            }
        }
        .listStyle(PlainListStyle())
    }
    
    //MARK: - Filter_ToDo_Today
    
    @ViewBuilder
    func filterToDoList() -> some View {
        List {
            Section(header: Text("Doing Today").font(.headline).foregroundColor(Color.blue)) {
                ForEach(itemsForToday) { itemToday in
                    if !itemToday.isDone {
                        ToDoListItemView(
                            listItem: itemToday, fontSize: 17)
                    }
                }
            }
        }
        .listStyle(PlainListStyle())
    }
    
    //MARK: - Filter_Done_Today
    
    @ViewBuilder
    func filterDoneList() -> some View {
        List {
            Section(header: Text("Done Today").font(.headline).foregroundColor(Color.blue)) {
                ForEach(itemsForToday) { itemToday in
                    if itemToday.isDone {
                        ToDoListItemView(
                            listItem: itemToday, fontSize: 17)
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
        .listStyle(PlainListStyle())
    }
    
    //MARK: - Dascription
    
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

struct ToDoListView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoListView(userId: "dK6CG6dD7vUwHggvLO2jjTauQGA3")
    }
}
