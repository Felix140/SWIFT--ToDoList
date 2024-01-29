import Foundation
import FirebaseAuth


class UserContact: User {
    var isSaved: Bool

    init(id: String, name: String, email: String, joined: TimeInterval, isSaved: Bool) {
        self.isSaved = isSaved
        super.init(id: id, name: name, email: email, joined: joined)
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}
