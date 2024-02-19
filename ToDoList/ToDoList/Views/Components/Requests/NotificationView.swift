import SwiftUI

struct NotificationView: View {
    
    @StateObject var viewModel = NotificationViewViewModel()
    @State var isClicked: Bool
    
    let taskObject: Notification
    var textTask: String
    var sendFrom: String
    var haptic = HapticTrigger()
    var onActionCompleted: () -> Void // Callback aggiunto
    
    var body: some View {
        VStack(alignment: .leading) {
            
            VStack(alignment: .leading) {
                Text(textTask)
                    .font(.system(size: CGFloat(18)))
                
                HStack {
                    Text("Inviato da: ")
                        .font(.footnote)
                    Text("\(sendFrom)")
                        .font(.footnote)
                        .fontWeight(.bold)
                }
            }
            .padding(.horizontal)
            
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
            viewModel.sendResponseAccepted(notification: taskObject)
            onActionCompleted() // Chiama il callback nel padre
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
            onActionCompleted() // Chiama il callback nel padre
        })
    }
}

//MARK: - PREVIEW

struct NotificationView_Preview: PreviewProvider {
    static var previews: some View {
        NotificationView(
            isClicked: false,
            taskObject: Notification(
                id: "123456789",
                sender: "sender",
                senderName: "Test",
                recipient: "123445",
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
                isShowed: true),
            textTask: "Questa è una task",
            sendFrom: "mittente",
            onActionCompleted: {}
        )
    }
}
