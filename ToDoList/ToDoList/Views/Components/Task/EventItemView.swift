import SwiftUI

struct EventItemView: View {
    
    @Binding var titleEvent: String
    
    var body: some View {
        Button(action: {
            
        }, label: {
            ZStack {
                Rectangle()
                    .fill(Theme.redGradient.gradient)
                    .cornerRadius(5.0)
                    .frame(height: 18)
                Text(titleEvent)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
            }
            .padding(.horizontal)
        })

    }
}

struct EventItem_Preview: PreviewProvider {
    static var previews: some View {
        EventItemView(titleEvent: .constant("titolo evento"))
    }
}
