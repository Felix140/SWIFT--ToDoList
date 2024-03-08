import SwiftUI

struct NotificationView: View {
    
    /// Action button su onActionCompleted
    enum ActionType {
        case accept, reject
    }
    
    @StateObject var viewModel = NotificationViewViewModel()
    @State var isClicked: Bool
    var isShowingButtons: Bool
    var isSendNotification: Bool
    let taskObject: Notification
    var textTask: String
    var sendFrom: String
    var haptic = HapticTrigger()
    var onActionCompleted: (ActionType) -> Void /// Callback con inserimento di parametro di tipo
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                HStack {
                    Text("\(Date(timeIntervalSince1970: taskObject.timeCreation).formatted(.dateTime.day(.twoDigits).month()))")
                        .font(.system(size: 10))
                    Text("\(Date(timeIntervalSince1970: taskObject.timeCreation).formatted(.dateTime.hour().minute()))")
                        .font(.system(size: 10))
                }
                HStack {
                    Text(textTask)
                        .font(.system(size: 18))
                    Spacer()
                }
                
                if !isSendNotification {
                    HStack {
                        Text("Send from: ")
                            .font(.footnote)
                        Text("\(sendFrom)")
                            .font(.footnote)
                            .fontWeight(.bold)
                    }
                } else {
                    HStack {
                        Text("Send to: ")
                            .font(.footnote)
                        Text("\(taskObject.recipient.name)")
                            .font(.footnote)
                            .fontWeight(.bold)
                    }
                }
            }
            .padding(.horizontal)
            
            if isShowingButtons {
                HStack(alignment: .center) {
                    acceptButton()
                    rejectButton()
                }
                .frame(width: UIScreen.main.bounds.width)
            }
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
            viewModel.sendResponseAccepted(notification: taskObject)
            onActionCompleted(.accept) /// Passa il tipo di azione al padre
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
            viewModel.sendResponseRejected(notification: taskObject)
            onActionCompleted(.reject) /// Passa il tipo di azione al padre
        })
    }
}

//MARK: - PREVIEW

struct NotificationView_Preview: PreviewProvider {
    static var previews: some View {
        NotificationView(
            isClicked: false,
            isShowingButtons: false,
            isSendNotification: true,
            taskObject: Notification(
                id: "123456789",
                sender: User(id: "1234", name: "1234", email: "1234", joined: Date().timeIntervalSince1970),
                recipient: User(id: "1234", name: "1234", email: "1234", joined: Date().timeIntervalSince1970),
                task: ToDoListItem(
                    id: "12345678",
                    title: "Ciao",
                    dueDate: 122312,
                    createdDate: 122312,
                    isDone: false,
                    category: .none,
                    description: InfoToDoItem(
                        id: "12345678",
                        description: "description")),
                isAccepted: false,
                isShowed: true,
                timeCreation: Date().timeIntervalSince1970),
            textTask: "Questa è una task Questa è una task Questa è una task Questa è una task Questa è una task",
            sendFrom: "mittente",
            onActionCompleted: {_ in }
        )
    }
}
