import Foundation

enum WidgetType: String {
    
    case todo

}

// MARK: - Helpers

extension WidgetType {
    var kind: String {
        rawValue + "Widget"
    }
}
