import SwiftUI
import WidgetKit
import FirebaseCore
import FirebaseAuth

@main
struct WidgetExamplesWidgetBundle: WidgetBundle {
    
    init() {
        FirebaseApp.configure()
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
