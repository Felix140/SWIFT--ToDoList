import SwiftUI

struct PomodoroTimerView: View {
    // Timer per lavoro e pausa
    @State private var workTimeRemaining = 40 * 60 // 40 minuti
    @State private var breakTimeRemaining = 5 * 60 // 5 minuti
    
    // Stati per controllare se il timer è attivo, il tipo di timer, e se è stato avviato
    @State private var isActive = false
    @State private var isWorkTimer = true
    @State private var isTimerStarted = false
    
    // Contatore per cicli completati
    @State private var cyclesCompleted = 0
    
    // Timer che scatta ogni secondo
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            TimerView(progress: progress)
            
            Text(isWorkTimer ? timeString(time: workTimeRemaining) : timeString(time: breakTimeRemaining))
                .font(.largeTitle)
            
            // Bottone per passare al timer successivo
            if isTimerStarted && isActive {
                Button("Next") {
                    self.nextTimer()
                }
                .font(.title)
            }
            
            // Bottone per pausa e ripresa
            Button(action: {
                self.isActive.toggle()
            }) {
                Text(isActive ? "Pausa" : "Riprendi")
                    .font(.title)
            }
            .disabled(!isTimerStarted)
            
            // Bottone per iniziare o resettare il timer
            Button(action: {
                if isTimerStarted {
                    self.resetTimer()
                } else {
                    self.startTimer()
                }
            }) {
                Text(isTimerStarted ? "Reset" : "Start")
                    .font(.title)
            }
        }
        .onReceive(timer) { _ in
            self.updateTimer()
        }
    }
    
    private func nextTimer() {
        // Funzione per passare al timer successivo
        if isWorkTimer {
            isWorkTimer = false
            breakTimeRemaining = 5 * 60
        } else {
            cyclesCompleted += 1
            isWorkTimer = true
            workTimeRemaining = 40 * 60
            if cyclesCompleted >= 4 {
                isActive = false
            }
        }
    }
    
    private func startTimer() {
        // Avvia il timer
        isActive = true
        isTimerStarted = true
    }
    
    private func resetTimer() {
        // Resetta il timer completamente
        workTimeRemaining = 40 * 60
        breakTimeRemaining = 5 * 60
        cyclesCompleted = 0
        isWorkTimer = true
        isActive = false
        isTimerStarted = false
    }
    
    private func updateTimer() {
        // Aggiorna il timer in base allo stato corrente
        guard isActive else { return }
        if isWorkTimer {
            if workTimeRemaining > 0 {
                workTimeRemaining -= 1
            } else {
                nextTimer()
            }
        } else {
            if breakTimeRemaining > 0 {
                breakTimeRemaining -= 1
            } else {
                nextTimer()
            }
        }
    }
    
    var progress: Double {
        // Calcola il progresso per la visualizzazione
        isWorkTimer ? Double(workTimeRemaining) / (40 * 60) : Double(breakTimeRemaining) / (5 * 60)
    }
    
    func timeString(time: Int) -> String {
        // Funzione per convertire il tempo in secondi in una stringa formattata
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
