import SwiftUI

struct HeaderView: View {
    
    let subTitle: String
    let icon: String
    let angle: Double
    
    
    var body: some View {
            VStack {
                Image("logo")
                    .resizable()
                    .frame(width: 150, height: 100)
                    .padding()
                
                HStack {
                    Text(subTitle)
                        .foregroundColor(Color.white)
                    Image(systemName: icon)
                        .foregroundColor(Color.white)
                }
            }
            .frame(width: UIScreen.main.bounds.width * 3, height: 600)
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(
                   subTitle: "SottoTitolo",
                   icon: "",
                   angle: 0)
        .previewLayout(.sizeThatFits)
    }
}
