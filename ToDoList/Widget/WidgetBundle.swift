import SwiftUI
import WidgetKit

@main
struct WidgetExamplesWidgetBundle: WidgetBundle {
    var body: some Widget {
        WidgetBundle1().body
    }
}

struct WidgetBundle1: WidgetBundle {
    var body: some Widget {
        
        ToDoItemsWidget()
        
    }
}
