import SwiftUI

struct HeaderView: View {
    
    let title: String
    let subTitle: String
    let icon: String
    let angle: Double
    
    var body: some View {
        ZStack {
            
            RoundedRectangle(cornerRadius: 0)
                .fill(Theme.redGradient.gradient)
                .rotationEffect(Angle(degrees: angle))
            
            
            VStack {
                Text(title)
                    .font(.system(size: 40))
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                
                HStack {
                    Text(subTitle)
                        .foregroundColor(Color.white)
                    Image(systemName: icon)
                        .foregroundColor(Color.white)
                }
            }
            
        }
        .frame(width: UIScreen.main.bounds.width * 3, height: 600)
        
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(title: "Titolo",
                   subTitle: "SottoTitolo",
                   icon: "",
                   angle: 0)
        .previewLayout(.sizeThatFits)
    }
}
