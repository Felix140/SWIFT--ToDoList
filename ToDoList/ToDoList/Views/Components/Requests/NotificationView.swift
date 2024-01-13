import SwiftUI

struct NotificationView: View {
    
    var text: String = "Questa è una notifica"
    
    var body: some View {
        Text(text)
    }
}

struct NotificationView_Preview: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}
