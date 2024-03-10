import Foundation

class FriendRequestNotification: Notification {
    
    enum FriendRequestState: String, Codable {
        case pending = "Pending Request"
        case confirmed = "Request Confirmed"
        case refused = "Request Refused"
    }
    
    let state: FriendRequestState
    
    enum CodingKeys: String, CodingKey {
        case state
    }
    
    required init(
        from decoder: Decoder
    ) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.state = try container.decode(FriendRequestState.self, forKey: .state)
        /// Chiama l'inizializzatore della superclasse
        try super.init(from: decoder)
    }
    
    init(
        id: String,
        sender: User,
        recipient: User,
        isShowed: Bool,
        timeCreation: TimeInterval,
        state: FriendRequestState
    ) {
        self.state = state
        super.init(
            id: id,
            sender: sender,
            recipient: recipient,
            isShowed: isShowed,
            timeCreation: timeCreation)
    }
}
