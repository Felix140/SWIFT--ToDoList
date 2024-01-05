import SwiftUI

struct PomodoroTimerView: View {
    // Timer per lavoro e pausa
    @State private var workTimeRemaining = 40 * 60 // 40 minuti
    @State private var breakTimeRemaining = 5 * 60 // 5 minuti
    
    // Stati per controllare se il timer è attivo, il tipo di timer, e se è stato avviato
    @State private var isActive = false
    @State private var isWorkTimer = true
    @State private var isTimerStarted = false
    
    // Contatore per cicli di lavoro completati
    @State private var workCyclesCompleted = 0
    
    // Timer che scatta ogni secondo
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            
            HStack {
                ForEach(0..<4, id: \.self) { index in
                    Image(systemName: "checkmark.circle")
                        .foregroundColor(index < workCyclesCompleted ? .green : .gray)
                        .scaleEffect(2.0)
                        .padding()
                }
            }
            
            // Bottone per passare al timer successivo
            HStack {
                if isTimerStarted && isActive {
                    Button("Next") {
                        self.nextTimer()
                    }
                    .font(.title)
                }
            }
            
            TimerView(progress: progress)
            
            Text(isWorkTimer ? timeString(time: workTimeRemaining) : timeString(time: breakTimeRemaining))
                .font(.largeTitle)
            
            
            
            HStack {
                // Bottone per pausa e ripresa
                Button(action: {
                    self.isActive.toggle()
                }) {
                    Text(isActive ? "Pausa" : "Riprendi")
                        .font(.title)
                }
                .disabled(!isTimerStarted)
                
                Spacer()
                
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
            .padding(.horizontal, 80)
        }
        .onReceive(timer) { _ in
            self.updateTimer()
        }
    }
    
    private func nextTimer() {
        // Funzione per passare al timer successivo
        if isWorkTimer {
            isWorkTimer = false
            workCyclesCompleted += 1
            breakTimeRemaining = 5 * 60
        } else {
            isWorkTimer = true
            workTimeRemaining = 40 * 60
            if workCyclesCompleted >= 4 {
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
        workCyclesCompleted = 0
        isWorkTimer = true
        isActive = false
        isTimerStarted = false
    }
    
    private func updateTimer() {
        guard isActive else { return }
        
        if isWorkTimer {
            if workTimeRemaining > 0 {
                workTimeRemaining -= 1
            } else {
                // Completa il ciclo di lavoro
                workCyclesCompleted += 1
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
