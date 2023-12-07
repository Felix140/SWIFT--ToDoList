import Foundation

class NewItemViewViewModel: ObservableObject {
    
    @Published var title = ""
    @Published var date = Date()
    
    init() {}
    
    func save() {
        print("New Item Saved")
    }
}
