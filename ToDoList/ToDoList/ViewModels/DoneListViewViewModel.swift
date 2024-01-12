import Foundation


class DoneListViewViewModel: ObservableObject {
    
    @Published var completedItems: [ToDoListItem] = []
    
    // Aggiungi la logica per aggiungere/rimuovere elementi da questo array
}
