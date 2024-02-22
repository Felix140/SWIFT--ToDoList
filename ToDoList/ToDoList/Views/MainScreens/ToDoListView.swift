import SwiftUI
import FirebaseFirestoreSwift
import WidgetKit

struct ToDoListView: View {
    
    /// @StateObject var viewModel = ToDoListViewViewModel()
    /// anziche creare uno StateObject come qui sopra, inizializziamo l'oggetto in init() per
    /// passargli il parametro dello userId, inizializzato a sua volta nell'init() di "ToDoListViewViewModel()"
    @StateObject var viewModel: ToDoListViewViewModel
    @StateObject var calendarViewModel: CalendarViewViewModel
    @FirestoreQuery var fetchedItems: [ToDoListItem]
    @State private var selectedPicker = 0
    @State private var itemToEdit: ToDoListItem? /// qui vado a storare la task premuta per renderla accessibile
    
    private var haptic = HapticTrigger()
    @State private var currentUserId: String = ""
    @State private var selectedTaskIds: Set<String> = []
    @State private var isSelectingItems: Bool = false
    
    @State private var selectByDate: Date? = nil /// Valore di partenza per visualizzare taskListAll()
    @State private var isOpenCalendar: Bool = false
    @State private var showBanner: Bool = false
    
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
        self._calendarViewModel = StateObject(wrappedValue: CalendarViewViewModel())
    }
    
    //MARK: - Body
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                // Banner
                if showBanner {
                    BannerView() // Rimuovi showBanner da qui
                        .transition(.asymmetric(insertion: .opacity.combined(with: .slide), removal: .scale.combined(with: .opacity)))
                        .animation(.easeInOut(duration: 0.5), value: showBanner)
                        .zIndex(1)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation {
                                    showBanner = false
                                }
                            }
                        }
                }
                
                mainContent()
                
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
    
    //MARK: - Main_Content
    
    @ViewBuilder
    func mainContent() -> some View {
        VStack {
            
            ProgressBarView(
                valueBar: Double(isDoneItemsForToday.count),
                totalValueBar: Double(itemsForToday.count))
            
            
            CustomPickerView(selectedPicker: $selectedPicker)
            
            
            if isOpenCalendar {
                CustomCalendarView(
                    eventStore: calendarViewModel,
                    selectedDate: Binding<Date?>(
                        get: { self.selectByDate ?? Date() },
                        set: { newValue in
                            self.selectByDate = newValue
                        }
                    ),
                    fetchItemsTask: .constant(fetchedItems),
                    scale: 1)
                .padding(.horizontal)
                .datePickerStyle(.graphical)
                .edgesIgnoringSafeArea(.bottom)
            }
            
            
            if selectByDate != nil {
                /// Mostra task filtrate se selectByDate NON è nil
                TabView(selection: $selectedPicker) {
                    taskFilteredByDate()
                        .tag(0)
                    filterToDoList()
                        .tag(1)
                    filterDoneList()
                        .tag(2)
                }
                .padding(.horizontal)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .edgesIgnoringSafeArea(.bottom) /// Permette di andare dietro la tabBar
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
                .padding(.horizontal)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .edgesIgnoringSafeArea(.bottom) /// Permette di andare dietro la tabBar
            }
        }
        .navigationTitle("TooDoo List")
        .toolbar{
            //MARK: - TOOLBAR
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    withAnimation(.easeIn(duration: 0.3)) {
                        self.haptic.feedbackMedium()
                        isSelectingItems = !isSelectingItems
                    }
                    if !isSelectingItems {
                        selectedTaskIds.removeAll()
                    }
                }, label: {
                    if isSelectingItems {
                        Image(systemName: "trash.fill")
                            .font(.system(size: 16))
                    } else {
                        Image(systemName: "trash")
                            .font(.system(size: 16))
                    }
                })
            }
            
            if isSelectingItems {
                ToolbarItem(placement: .principal) {
                    Text("Selected Tasks: \(selectedTaskIds.count)")
                        .foregroundColor(.primary)
                }
                ToolbarItem(placement: .confirmationAction)  {
                    HStack(spacing: 10) {
                        Button("Delete", action: {
                            self.haptic.feedbackHeavy()
                            viewModel.deleteByGroup(idItems: Array(selectedTaskIds))
                            isSelectingItems = false
                            selectedTaskIds.removeAll()
                            withAnimation {
                                showBanner = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                withAnimation {
                                    showBanner = false
                                }
                            }
                        })
                        .foregroundStyle(Color.red)
                        .disabled(selectedTaskIds.isEmpty)
                        .transition(.asymmetric(insertion: .opacity.combined(with: .opacity), removal: .scale.combined(with: .opacity)))
                    }
                }
            } else {
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: {
                        haptic.feedbackMedium()
                        withAnimation(.easeInOut(duration: 0.3)) { /// Qui setto la velocità di apertura del calendario
                            self.isOpenCalendar.toggle()
                        }
                    }) {
                        Image(systemName: isOpenCalendar ? "chevron.up.circle.fill" : "calendar.circle")
                            .font(.system(size: 20))
                    }
                    .accessibilityLabel("Calendar")
                    .transition(.asymmetric(insertion: .opacity.combined(with: .opacity), removal: .scale.combined(with: .opacity)))
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
        }
        .onAppear {
            if Bundle.main.bundleIdentifier != nil {
                WidgetCenter.shared.reloadTimelines(ofKind: "TooDooWidget")
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
                            .onLongPressGesture(minimumDuration: 0.1) {
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
                            .onLongPressGesture(minimumDuration: 0.1) {
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
                            .onLongPressGesture(minimumDuration: 0.1) {
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
            .edgesIgnoringSafeArea(.bottom)
        }
        .listStyle(PlainListStyle())
        
    }
    
    
    //MARK: - Filtered_By_Day_Selected
    
    @ViewBuilder
    func taskFilteredByDate() -> some View {
        List {
            
            Section {
                HStack(alignment: .center) {
                    Button(action: {
                        haptic.feedbackMedium()
                        withAnimation(.easeInOut(duration: 0.2)) { /// velocita di sparizione bottone
                            self.selectByDate = nil /// Pulisce la selezione della data
                        }
                    }) {
                        
                        HStack {
                            Image(systemName: "list.bullet.below.rectangle")
                                .font(.system(size: 20))
                                .foregroundStyle(Theme.redGradient.gradient)
                            Text("Show All Tasks")
                                .foregroundStyle(Theme.redGradient.gradient)
                                .fontWeight(.semibold)
                        }
                        
                    }
                    .transition(.asymmetric(insertion: .scale.combined(with: .opacity), removal: .scale.combined(with: .opacity)))
                }
                .frame(width: UIScreen.main.bounds.width)
            }
            
            Section(header: Text(selectByDate ?? Date() , format: .dateTime.day().month().year()).font(.headline).foregroundColor(Color.blue)) {
                ForEach(filteredItemsBySelectedDate) { itemFiltered in
                    HStack {
                        VStack {
                            ToDoListItemView(
                                listItem: itemFiltered, fontSize: 17)
                            .onLongPressGesture(minimumDuration: 0.1) {
                                withAnimation(.bouncy(duration: 2)) {
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

//MARK: - PREVIEW

struct ToDoListView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoListView(userId: "dK6CG6dD7vUwHggvLO2jjTauQGA3")
    }
}
