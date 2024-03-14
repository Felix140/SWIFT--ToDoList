import Foundation

extension Encodable {
    
    func asDictionary() -> [String: Any] {
        guard let data = try? JSONEncoder().encode(self) else {
            return [:] /// Dizionario Vuoto
        }
        do {
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            return json ?? [:] ///ritorna un Dizionario ALTRIMENTI un Dizionario Vuoto
        } catch {
            return [:] /// Dizionario Vuoto
        }
    }
    
    
    func taskNotificationsAsDictionary(for notification: TaskNotification) -> [String: Any] {
        var dict = notification.asDictionary()
        dict["task"] = notification.task.asDictionary()
        dict["isAccepted"] = notification.isAccepted
        return dict
    }
    
    func friendNotificationsAsDictionary(for friendRequest: FriendRequestNotification) -> [String: Any] {
        var dict = friendRequest.asDictionary()
//        dict["state"] = friendRequest.asDictionary()
        dict["userContact"] = friendRequest.asDictionary()
        return dict
    }

}
