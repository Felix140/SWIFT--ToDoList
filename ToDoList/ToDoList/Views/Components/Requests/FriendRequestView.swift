import SwiftUI

struct FriendRequestView: View {
    
    /// Action button su onActionCompleted
    enum ActionType {
        case acceptFriend, rejectFriend
    }
    
    @StateObject var viewModel = NotificationViewViewModel()
    let friendRequestObject: FriendRequestNotification
    var sendFrom: String
    var haptic = HapticTrigger()
    var onActionCompleted: (ActionType) -> Void
    
    
    var body: some View {
        VStack {
            Grid {
                GridRow {
                    Text("\(sendFrom)")
                        .font(.headline)
                    Text("sent you a")
                    Text("friend request")
                        .font(.headline)
                }
            }
            
            
            HStack(alignment: .center) {
                acceptButton()
                rejectButton()
            }
            .frame(width: UIScreen.main.bounds.width)
            
        }
    }
    
    //MARK: - Buttons
    
    func acceptButton() -> some View {
        Button(action: {}, label: {
            ZStack {
                Rectangle()
                    .cornerRadius(8.0)
                    .frame(width: UIScreen.main.bounds.width / 5,height: 25)
                    .foregroundColor(.blue)
                Text("Confirm")
                    .foregroundColor(.white)
                    .font(.system(size: 12))
                    .fontWeight(.bold)
            }
        })
        .simultaneousGesture(TapGesture().onEnded { /// previene il BUBBLING
            self.haptic.feedbackLight()
        })
    }
    
    func rejectButton() -> some View {
        Button(action: {}, label: {
            ZStack {
                Rectangle()
                    .cornerRadius(8.0)
                    .frame(width: UIScreen.main.bounds.width / 5,height: 25)
                    .foregroundColor(.gray)
                
                
                Text("Reject")
                    .foregroundColor(.white)
                    .font(.system(size: 12))
                    .fontWeight(.bold)
            }
        })
        .simultaneousGesture(TapGesture().onEnded { /// previene il BUBBLING
            self.haptic.feedbackLight()
        })
    }
}

