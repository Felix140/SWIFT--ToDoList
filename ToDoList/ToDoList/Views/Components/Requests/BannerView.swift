import SwiftUI


struct BannerView: View {
    
    var body: some View {
        // La tua implementazione attuale va bene, rimuovi solo la variabile @State showBanner
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.blue)
                .frame(width: UIScreen.main.bounds.width * 0.9, height: 50) // Usa una dimensione fissa per l'altezza
                .shadow(radius: 10)
            Text("Operazione completata!") // Messaggio esemplificativo
                .foregroundColor(.white)
        }
    }
}

struct BannerView_Preview: PreviewProvider {
    static var previews: some View {
        BannerView()
    }
}
