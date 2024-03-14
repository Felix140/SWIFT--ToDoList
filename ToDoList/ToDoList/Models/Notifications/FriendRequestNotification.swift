import Foundation

class FriendRequestNotification: Notification {
    
    enum FriendRequestState: String, Codable {
        case pending = "pending"
        case confirmed = "confirmed"
        case refused = "refused"
    }
    
    let state: FriendRequestState.RawValue
    let userContact: UserContact
    
    enum CodingKeys: String, CodingKey {
        case state
        case userContact
    }
    
    required init(
        from decoder: Decoder
    ) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.state = try container.decode(FriendRequestState.RawValue.self, forKey: .state)
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
        state: FriendRequestState.RawValue,
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
