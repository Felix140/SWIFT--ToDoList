import SwiftUI

struct ProfileImageView: View {
    var body: some View {
        Image("turtlerock")
            .resizable()
            .frame(width: 125, height: 125)
            .clipShape(Circle())
            .overlay {
                Circle()
                    .stroke(.white, lineWidth: 4.0)
            }
            .shadow(radius: 1)
    }
}

#Preview {
    ProfileImageView()
}
