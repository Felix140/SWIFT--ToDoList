import SwiftUI
import FirebaseFirestoreSwift
import WidgetKit

struct ToDoListView: View {
    
    /// @StateObject var viewModel = ToDoListViewViewModel()
    /// anziche creare uno StateObject come qui sopra, inizializziamo l'oggetto in init() per
    /// passargli il parametro dello userId, inizializzato a sua volta nell'init() di "ToDoListViewViewModel()"
    @StateObject var viewModel: ToDoListViewViewModel
    @FirestoreQuery var fetchedItems: [ToDoListItem]
    @State private var selectedPicker = 0
    @State private var itemToEdit: ToDoListItem? /// qui vado a storare la task premuta per renderla accessibile
    
    private var haptic = HapticTrigger()
    @State private var currentUserId: String = ""
    @State private var selectedTaskIds: Set<String> = []
    @State private var isSelectingItems: Bool = false
    
    @State private var selectByDate: Date? = nil /// Valore di partenza per visualizzare taskListAll()
    @State private var isOpenCalendar: Bool = false
    
    // TODAY items
    private var itemsForToday: [ToDoListItem] {
        fetchedItems.filter { item in
            let itemDate = Date(timeIntervalSince1970: item.dueDate) /// convert to Date
            if Bundle.main.bundleIdentifier != nil {
                WidgetCenter.shared.reloadTimelines(ofKind: "TooDooWidget")
            }
            return Calendar.current.isDateInToday(itemDate)
        }
        .sorted(by: { $0.dueDate < $1.dueDate }) /// ordina per orario
    }
    
    // TOMORROW items
    private var itemsForTomorrow: [ToDoListItem] {
        fetchedItems.filter { item in
            let itemDate = Date(timeIntervalSince1970: item.dueDate) /// converto to Date
            return Calendar.current.isDateInTomorrow(itemDate)
        }
        .sorted(by: { $0.dueDate < $1.dueDate }) /// ordina per orario
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
        .sorted(by: { $0.dueDate < $1.dueDate }) /// Li ordino dal giorno più recente al più lontano
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
    
    //MARK: - INIT
    
    init(userId: String) {
        /// users/<id>/todos/<entries>
        self._fetchedItems = FirestoreQuery(
            collectionPath: "users/\(userId)/todos/") // GET query
        /// inizializzo qui sotto viewModel come StateObject
        self._viewModel = StateObject(wrappedValue: ToDoListViewViewModel(userId: userId))
        self._currentUserId = State(wrappedValue: userId)
    }
    
    //MARK: - Body
    
    var body: some View {
        NavigationView {
            VStack {
                
                ProgressBarView(
                    valueBar: Double(isDoneItemsForToday.count),
                    totalValueBar: Double(itemsForToday.count))
                
                
                CustomPickerView(selectedPicker: $selectedPicker)
                
                
                if isOpenCalendar {
                    DatePicker(
                        "Select Date",
                        selection: Binding<Date>(
                            get: { self.selectByDate ?? Date() },
                            set: { newValue in
                                self.selectByDate = newValue
                            }
                        ),
                        displayedComponents: [.date]
                    )
                        .padding(.horizontal)
                        .datePickerStyle(.graphical)
                }
                
                
                if let selectByDate = selectByDate {
                    
                    Button(action: {
                        haptic.feedbackMedium()
                        self.selectByDate = nil /// Pulisce la selezione della data
                    }) {
                        HStack {
                            Image(systemName: "list.bullet.below.rectangle")
                                .font(.system(size: 20))
                            Text("Show All Tasks")
                        }
                    }
                    .padding(0)
                    /// Mostra task filtrate se selectByDate NON è nil
                    TabView(selection: $selectedPicker) {
                        taskFilteredByDate()
                            .tag(0)
                        filterToDoList()
                            .tag(1)
                        filterDoneList()
                            .tag(2)
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                } else {
                    /// Mostra tutte le task se selectByDate è nil
                    TabView(selection: $selectedPicker) {
                        taskListAll()
                            .tag(0)
                        filterToDoList()
                            .tag(1)
                        filterDoneList()
                            .tag(2)
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                }
                
                Spacer()
                
                
            }
            .navigationTitle("TooDoo List")
            .toolbar{
                
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        Button("Delete Selection") {
                            isSelectingItems = true
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .font(.system(size: 20))
                    }
                }
                
                if isSelectingItems {
                    ToolbarItem(placement: .principal)  {
                        HStack(spacing: 10) {
                            
                            Button("Cancel") {
                                isSelectingItems = false
                                selectedTaskIds.removeAll()
                            }
                            
                            Button("Delete", action: {
                                viewModel.deleteByGroup(idItems: Array(selectedTaskIds))
                                isSelectingItems = false
                                selectedTaskIds.removeAll()
                            })
                            .foregroundStyle(Color.red)
                            .disabled(selectedTaskIds.isEmpty)
                        }
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: {
                        haptic.feedbackMedium()
                        withAnimation(.easeInOut(duration: 0.3)) { /// Qui setto la velocità di apertura del calendario
                            self.isOpenCalendar.toggle()
                        }
                    }) {
                        Image(systemName: isOpenCalendar ? "calendar.circle.fill" : "calendar.circle")
                            .font(.system(size: 20))
                    }
                    .accessibilityLabel("Calendar")
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: {
                        self.haptic.feedbackMedium()
                        viewModel.isPresentingView = true
                        if Bundle.main.bundleIdentifier != nil {
                            WidgetCenter.shared.reloadTimelines(ofKind: "TooDooWidget")
                        }
                    }) {
                        Image(systemName: "plus.app")
                            .font(.system(size: 23))
                            .foregroundColor(Color.clear) /// Make the original icon transparent
                            .background(Theme.red.gradient) /// Apply the gradient as background
                            .mask(Image(systemName: "plus.app").font(.system(size: 23))) /// generate a mask
                    }
                    .accessibilityLabel("Add New Task")
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
                    HStack {
                        VStack {
                            ToDoListItemView(
                                listItem: itemToday, fontSize: 17)
                            .onLongPressGesture {
                                withAnimation(.default) {
                                    self.haptic.feedbackLight()
                                    self.itemToEdit = itemToday /// Aggiorna itemToEdit con l'elemento corrente
                                    viewModel.onOpenEditButtons(item: itemToday)
                                }
                            }
                            if itemToday.description.description != "" {
                                description(text: itemToday.description.description)
                            }
                        }
                        .sheet(isPresented: $viewModel.isPresentingSetView) {
                            /// Aggiornare ItemToEdit
                            if let itemToEdit = itemToEdit {
                                NavigationStack {
                                    EditItemTaskView(
                                        toggleView: $viewModel.isPresentingSetView,
                                        itemToSet: .constant(itemToEdit),
                                        viewModelEdit: viewModel
                                    )
                                }
                            }
                        }
                        
                        if isSelectingItems {
                            Image(systemName: selectedTaskIds.contains(itemToday.id) ? "checkmark.square.fill" : "square")
                                .onTapGesture {
                                    if selectedTaskIds.contains(itemToday.id) {
                                        selectedTaskIds.remove(itemToday.id)
                                    } else {
                                        selectedTaskIds.insert(itemToday.id)
                                    }
                                }
                                .foregroundColor(Color.red)
                        }
                    }
                }
                .actionSheet(isPresented: $viewModel.showingDeleteConfirmation) {
                    ActionSheet(title: Text("Action selection"), buttons: [
                        .default(Text("Edit")) {
                            viewModel.isPresentingSetView = true
                        },
                        .destructive(Text("Delete")) {
                            viewModel.confirmAndDelete()
                        },
                        .cancel()
                    ])
                }
            }
            
            
            Section(header: Text("Tomorrow").font(.headline)) {
                ForEach(itemsForTomorrow) { itemTomorrow in
                    HStack {
                        VStack {
                            ToDoListItemView(
                                listItem: itemTomorrow, fontSize: 15)
                            .onLongPressGesture {
                                withAnimation(.default) {
                                    self.haptic.feedbackLight()
                                    self.itemToEdit = itemTomorrow /// Aggiorna itemToEdit con l'elemento corrente
                                    viewModel.onOpenEditButtons(item: itemTomorrow)
                                }
                            }
                            if itemTomorrow.description.description != "" {
                                description(text: itemTomorrow.description.description)
                            }
                        }
                        .sheet(isPresented: $viewModel.isPresentingSetView) {
                            if let itemToEdit = itemToEdit {
                                NavigationStack {
                                    EditItemTaskView(
                                        toggleView: $viewModel.isPresentingSetView,
                                        itemToSet: .constant(itemToEdit),
                                        viewModelEdit: viewModel
                                    )
                                }
                            }
                        }
                        
                        if isSelectingItems {
                            Image(systemName: selectedTaskIds.contains(itemTomorrow.id) ? "checkmark.square.fill" : "square")
                                .onTapGesture {
                                    if selectedTaskIds.contains(itemTomorrow.id) {
                                        selectedTaskIds.remove(itemTomorrow.id)
                                    } else {
                                        selectedTaskIds.insert(itemTomorrow.id)
                                    }
                                }
                                .foregroundColor(Color.red)
                        }
                    }
                }
                .actionSheet(isPresented: $viewModel.showingDeleteConfirmation) {
                    ActionSheet(title: Text("Actions selection"), buttons: [
                        .default(Text("Edit")) {
                            viewModel.isPresentingSetView = true
                        },
                        .destructive(Text("Delete")) {
                            viewModel.confirmAndDelete()
                        },
                        .cancel()
                    ])
                }
            }
            
            Section(header: Text("After Tomorrow").font(.headline)) {
                ForEach(itemsAfterTomorrow) { itemAfter in
                    HStack {
                        VStack {
                            ToDoListItemView(
                                listItem: itemAfter, fontSize: 15)
                            .onLongPressGesture {
                                withAnimation(.default) {
                                    self.haptic.feedbackLight()
                                    self.itemToEdit = itemAfter /// Aggiorna itemToEdit con l'elemento corrente
                                    viewModel.onOpenEditButtons(item: itemAfter)
                                }
                            }
                            if itemAfter.description.description != "" {
                                description(text: itemAfter.description.description)
                            }
                        }
                        .sheet(isPresented: $viewModel.isPresentingSetView) {
                            if let itemToEdit = itemToEdit {
                                NavigationStack {
                                    EditItemTaskView(
                                        toggleView: $viewModel.isPresentingSetView,
                                        itemToSet: .constant(itemToEdit),
                                        viewModelEdit: viewModel
                                    )
                                }
                            }
                        }
                        
                        if isSelectingItems {
                            Image(systemName: selectedTaskIds.contains(itemAfter.id) ? "checkmark.square.fill" : "square")
                                .onTapGesture {
                                    if selectedTaskIds.contains(itemAfter.id) {
                                        selectedTaskIds.remove(itemAfter.id)
                                    } else {
                                        selectedTaskIds.insert(itemAfter.id)
                                    }
                                }
                                .foregroundColor(Color.red)
                        }
                    }
                }
                .actionSheet(isPresented: $viewModel.showingDeleteConfirmation) {
                    ActionSheet(title: Text("Actions selection"), buttons: [
                        .default(Text("Edit")) {
                            viewModel.isPresentingSetView = true
                        },
                        .destructive(Text("Delete")) {
                            viewModel.confirmAndDelete()
                        },
                        .cancel()
                    ])
                }
            }
        }
        .listStyle(PlainListStyle())
    }
    
    
    //MARK: - Filtered_By_Day_Selected
    
    @ViewBuilder
    func taskFilteredByDate() -> some View {
        List {
            Section(header: Text(selectByDate ?? Date() , format: .dateTime.day().month().year()).font(.headline).foregroundColor(Color.blue)) {
                ForEach(filteredItemsBySelectedDate) { itemFiltered in
                    HStack {
                        VStack {
                            ToDoListItemView(
                                listItem: itemFiltered, fontSize: 17)
                            .onLongPressGesture {
                                withAnimation(.default) {
                                    self.haptic.feedbackLight()
                                    self.itemToEdit = itemFiltered // Aggiorna itemToEdit con l'elemento corrente
                                    viewModel.onOpenEditButtons(item: itemFiltered)
                                }
                            }
                            if itemFiltered.description.description != "" {
                                description(text: itemFiltered.description.description)
                            }
                        }
                        .sheet(isPresented: $viewModel.isPresentingSetView) {
                            if let itemToEdit = itemToEdit {
                                NavigationStack {
                                    EditItemTaskView(
                                        toggleView: $viewModel.isPresentingSetView,
                                        itemToSet: .constant(itemToEdit),
                                        viewModelEdit: viewModel
                                    )
                                }
                            }
                        }
                        
                        if isSelectingItems {
                            Image(systemName: selectedTaskIds.contains(itemFiltered.id) ? "checkmark.square.fill" : "square")
                                .onTapGesture {
                                    if selectedTaskIds.contains(itemFiltered.id) {
                                        selectedTaskIds.remove(itemFiltered.id)
                                    } else {
                                        selectedTaskIds.insert(itemFiltered.id)
                                    }
                                }
                                .foregroundColor(Color.red)
                        }
                    }
                }
                .actionSheet(isPresented: $viewModel.showingDeleteConfirmation) {
                    ActionSheet(title: Text("Action selection"), buttons: [
                        .default(Text("Edit")) {
                            viewModel.isPresentingSetView = true
                        },
                        .destructive(Text("Delete")) {
                            viewModel.confirmAndDelete()
                        },
                        .cancel()
                    ])
                }
            }
        }
        .listStyle(PlainListStyle())
    }

    
    
    private var filteredItemsBySelectedDate: [ToDoListItem] {
        fetchedItems.filter { item in
            let itemDate = Date(timeIntervalSince1970: item.dueDate)
            let calendar = Calendar.current
            return calendar.isDate(itemDate, inSameDayAs: selectByDate ?? Date() )
        }
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
