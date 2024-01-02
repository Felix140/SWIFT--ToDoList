import SwiftUI

struct PomodoroTimerView: View {
    // Stato per tenere traccia del tempo rimanente (in secondi)
    @State private var timeRemaining = 40 * 60 // 25 minuti
    
    // Stato per controllare se il timer è attivo
    @State private var isActive = false

    // Timer che scatta ogni secondo
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var progress: Double {
        return Double(timeRemaining) / (40 * 60)
    }

    var body: some View {
        VStack {
            TimerView(progress: progress)
            
            Text(timeString(time: timeRemaining))
                .font(.largeTitle)

            Button(action: {
                self.isActive.toggle()
                if self.isActive {
                    self.timeRemaining = 40 * 60 // Reset del timer a 25 minuti
                }
            }) {
                Text(isActive ? "Stop" : "Start")
                    .font(.title)
            }
        }
        .onReceive(timer) { _ in
            if self.isActive && self.timeRemaining > 0 {
                self.timeRemaining -= 1
            }
        }
    }

    // Funzione per convertire il tempo in secondi in una stringa formattata
    func timeString(time: Int) -> String {
        let minutes = time / 60
        let seconds = time % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
}

struct PomodoroTimerView_Previews: PreviewProvider {
    static var previews: some View {
        PomodoroTimerView()
    }
}
