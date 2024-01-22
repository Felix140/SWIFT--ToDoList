import SwiftUI

struct NotificationView: View {
    
    @StateObject var viewModel = NotificationViewViewModel()
    var textTask: String
    var sendFrom: String
    var haptic = HapticTrigger()
    
    @Binding var alert: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(textTask)
                    .font(.system(size: CGFloat(18)))
                
                HStack {
                    Text("Inviato da: ")
                        .font(.footnote)
                    Text("\(sendFrom)")
                        .font(.footnote)
                        .fontWeight(.bold)
                    
                    Spacer()
                }
            }
            
            Spacer()
            
            HStack {
                rejectButton()
                acceptButton()
            }
        }
    }
    
    
    @ViewBuilder
    func acceptButton() -> some View {
        Button(action: {}, label: {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 38))
                .accentColor(.green)
        })
        .frame(width: 50 / 1.1)
        .simultaneousGesture(TapGesture().onEnded {
            self.haptic.feedbackLight()
            alert = true
            viewModel.sendResponseAccepted()
        })
        
        Spacer()
            .frame(width: 10)
    }
    
    
    @ViewBuilder
    func rejectButton() -> some View {
        Button(action: {}, label: {
            Image(systemName: "xmark.circle.fill")
                .font(.system(size: 38))
                .accentColor(.red)
        })
        .frame(width: 50 / 1.1)
        .simultaneousGesture(TapGesture().onEnded { /// previene il BUBBLING
            self.haptic.feedbackLight()
            alert = true
            viewModel.sendResponseRejected()
        })
        
        Spacer()
            .frame(width: 10)
    }
}

struct NotificationView_Preview: PreviewProvider {
    static var previews: some View {
        NotificationView(
            textTask: "Questa è una task",
            sendFrom: "mittente",
            alert: .constant(false))
    }
}
