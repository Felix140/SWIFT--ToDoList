import Foundation

enum TypologyNotification: String, Codable {
    case taskRequest = "taskRequest"
    case friendRequest = "friendRequest"
    case textNotification = "textNotification"
}
