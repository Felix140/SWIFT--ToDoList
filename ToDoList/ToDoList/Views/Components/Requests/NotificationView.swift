import SwiftUI

struct NotificationView: View {
    
    @EnvironmentObject var viewModel: NotificationViewViewModel
    var textTask: String
    var sendFrom: String
    var haptic = HapticTrigger()
    
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
        Button(action: {
            self.haptic.feedbackLight()
            viewModel.sendResponseAccepted()
        }, label: {
            ZStack {
                
                if #available(iOS 17.0, *) {
                    Circle()
                        .stroke(Theme.redGradient.gradient, lineWidth: 3)
                        .fill(Color.clear)
                        .cornerRadius(100.0)
                        .frame(width: 38)
                } else {
                    Circle()
                        .fill(Theme.redGradient.gradient)
                        .cornerRadius(100.0)
                        .frame(width: 38)
                }
                
                Image(systemName: "checkmark")
                    .font(.system(size: 18))
                    .foregroundColor(Color.clear)
                    .background(Theme.redGradient.gradient)
                    .mask(Image(systemName: "checkmark").font(.system(size: 18)))
                    .fontWeight(.bold)
            }
        })
        .frame(width: 50 / 1.1)
        .simultaneousGesture(TapGesture().onEnded { /// previene il BUBBLING
            
        })
        
        Spacer()
            .frame(width: 10)
    }
    
    
    @ViewBuilder
    func rejectButton() -> some View {
        Button(action: {
            self.haptic.feedbackLight()
            viewModel.sendResponseRejected()
        }, label: {
            ZStack {
                
                if #available(iOS 17.0, *) {
                    Circle()
                        .stroke(Theme.redGradient.gradient, lineWidth: 3)
                        .fill(Color.clear)
                        .cornerRadius(100.0)
                        .frame(width: 38)
                } else {
                    Circle()
                        .fill(Theme.redGradient.gradient)
                        .cornerRadius(100.0)
                        .frame(width: 38)
                }
                
                Image(systemName: "xmark")
                    .font(.system(size: 18))
                    .foregroundColor(Color.clear)
                    .background(Theme.redGradient.gradient)
                    .mask(Image(systemName: "xmark").font(.system(size: 18)))
                    .fontWeight(.bold)
            }
        })
        .frame(width: 50 / 1.1)
        .simultaneousGesture(TapGesture().onEnded { /// previene il BUBBLING
            
        })
        
        Spacer()
            .frame(width: 10)
    }
}

struct NotificationView_Preview: PreviewProvider {
    static var previews: some View {
        NotificationView(textTask: "Questa è una task", sendFrom: "mittente")
    }
}
