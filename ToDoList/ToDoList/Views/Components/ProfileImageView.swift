import SwiftUI

struct ProfileImageView: View {
    
    @State var profileImg: String
    
    var body: some View {
        Image(profileImg)
            .resizable()
            .frame(width: 80, height: 80)
            .clipShape(Circle())
            .overlay {
                Circle()
                    .stroke(.white, lineWidth: 3.0)
            }
            .shadow(radius: 1)
    }
}

#Preview {
    ProfileImageView(
        profileImg: "turtlerock"
    )
}
