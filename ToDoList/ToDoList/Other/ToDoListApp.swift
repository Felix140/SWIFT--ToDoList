
import SwiftUI
import FirebaseCore
import FirebaseAuth

@main
struct ToDoListApp: App {
    
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
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
