import Foundation

class FriendRequestNotification: Notification {
    
    let status: StatusTypology.RawValue
    let userContact: UserContact
    
    enum CodingKeys: String, CodingKey {
        case status
        case userContact
    }
    
    required init(
        from decoder: Decoder
    ) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status = try container.decode(StatusTypology.RawValue.self, forKey: .status)
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
        status: StatusTypology.RawValue,
        userContact: UserContact
    ) {
        self.status = status
        self.userContact = userContact
        super.init(
            id: id,
            sender: sender,
            recipient: recipient,
            isShowed: isShowed,
            timeCreation: timeCreation, 
            type: .friendRequest)
    }
}
