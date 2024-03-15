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
        var dictUserContact = friendRequest.userContact.asDictionary()
        /// modifica sia fatta prima di assegnare dictUserContact a dict
        dictUserContact["isSaved"] = friendRequest.userContact.isSaved
        dict["userContact"] = dictUserContact
        dict["state"] = friendRequest.state
        return dict
    }
    
    func userContactAsDictionary(for userContact: UserContact) -> [String: Any] {
        var dict = userContact.asDictionary()
        dict["isSaved"] = userContact.isSaved
        return dict
    }

}
