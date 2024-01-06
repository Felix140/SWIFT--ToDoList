import Foundation


struct InfoToDoItem: Identifiable, Codable {
    
    let id: String
    let description: String
   
    init(id: String, description: String) {
        self.id = id
        self.description = description
    }
    
}
