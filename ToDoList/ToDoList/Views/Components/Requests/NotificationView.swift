import SwiftUI

struct NotificationView: View {
    
    @EnvironmentObject var viewModel: NotificationViewViewModel
    var textTask: String
    var sendFrom: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(textTask)
                Text("Inviato da: \(sendFrom)")
                    .font(.footnote)
            }
            
            Spacer()
        }
    }
}

struct NotificationView_Preview: PreviewProvider {
    static var previews: some View {
        NotificationView(textTask: "Questa è una task", sendFrom: "mittente")
    }
}
