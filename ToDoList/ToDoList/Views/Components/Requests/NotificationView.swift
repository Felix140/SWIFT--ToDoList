import SwiftUI

struct NotificationView: View {
    
    var textTask: String
    var sendFrom: String
    
    var body: some View {
        VStack {
            Text(textTask)
            Text(sendFrom)
        }
    }
}

struct NotificationView_Preview: PreviewProvider {
    static var previews: some View {
        NotificationView(textTask: "Questa è una task", sendFrom: "Pincopallino")
    }
}
