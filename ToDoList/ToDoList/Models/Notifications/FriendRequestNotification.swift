import Foundation

class FriendRequestNotification: Notification {
    
    enum FriendRequestState: String, Codable {
        case pending = "Pending Request"
        case confirmed = "Request Confirmed"
        case refused = "Request Refused"
    }
    
    let state: FriendRequestState
    let userContact: UserContact
    
    enum CodingKeys: String, CodingKey {
        case state
        case userContact
    }
    
    required init(
        from decoder: Decoder
    ) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.state = try container.decode(FriendRequestState.self, forKey: .state)
        self.userContact = try container.decode(UserContact.self, forKey: .userContact)
        /// Chiama l'inizializzatore della superclasse
        try super.init(from: decoder)
    }
    
    init(
        id: String,
        sender: User,
        recipient: User,
        isShowed: Bool,
        timeCreation: TimeInterval,
        state: FriendRequestState,
        userContact: UserContact
    ) {
        self.state = state
        self.userContact = userContact
        super.init(
            id: id,
            sender: sender,
            recipient: recipient,
            isShowed: isShowed,
            timeCreation: timeCreation)
    }
}
