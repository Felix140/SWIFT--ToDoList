import SwiftUI
import WidgetKit
import FirebaseCore
import FirebaseAuth

@main
struct WidgetExamplesWidgetBundle: WidgetBundle {
    
    init() {
        FirebaseApp.configure()
        
//        do {
//            
//            try Auth.auth().useUserAccessGroup("com.felixvaldez.ToDoList")
//            
//        } catch {
//            
//            print(error.localizedDescription)
//            print("ERRORE AUTH @main widget")
//        }
    }
    
    var body: some Widget {
        WidgetBundle1().body
    }
}

struct WidgetBundle1: WidgetBundle {
    var body: some Widget {
        
        ToDoItemsWidget()
        
    }
}
