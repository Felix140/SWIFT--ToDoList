import SwiftUI
import AVFoundation

struct PomodoroTimerView: View {
    
    @State private var selectedWorkTime = 40 /// Tempo di lavoro predefinito (in minuti)
    @State private var selectedBreakTime = 5 /// Tempo di pausa predefinito (in minuti)
    @State private var workTimeRemaining: Int = 40 * 60 // Imposta il valore iniziale
    @State private var breakTimeRemaining: Int = 5 * 60 // Imposta il valore iniziale
    
    // Stati per controllare se il timer è attivo, il tipo di timer, e se è stato avviato
    @State private var isActive = false
    @State private var isWorkTimer = true
    @State private var isTimerStarted = false
    
    @State private var workCyclesCompleted = 0 /// Contatore per cicli di lavoro completati
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect() /// Timer che scatta ogni secondo
    @State private var showAlert = false /// Alert
    ///
    
    init() {
        // Imposta i tempi iniziali in secondi
        _workTimeRemaining = State(initialValue: selectedWorkTime * 60)
        _breakTimeRemaining = State(initialValue: selectedBreakTime * 60)
    }
    
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
                
                Spacer()
                
                Button("Click") {
                    showAlert = true
                }
            }
            
            // Selezioni per i tempi di lavoro e pausa
            if !isTimerStarted {
                
                Picker("Work Time", selection: $selectedWorkTime) {
                    ForEach(20...60, id: \.self) { time in
                        Text("\(time) minutes").tag(time)
                    }
                }
                .pickerStyle(.wheel)
                
                Picker("Break Time", selection: $selectedBreakTime) {
                    ForEach(1...15, id: \.self) { time in
                        Text("\(time) minutes").tag(time)
                    }
                }
                .pickerStyle(.wheel)
                
            }
            
            
            if isTimerStarted {
                TimerView(progress: progress)
            }
            
            
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
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Fai Una Pausa"),
                    message: Text("Il periodo di lavoro è finito. È ora di una pausa di \(selectedBreakTime) minuti."),
                    dismissButton: .default(Text("OK"))
                )
            }
            .onReceive(timer) { _ in
                if showAlert {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                        showAlert = false /// faccio chiudere l'alert dopo 4 secondi
                    }
                }
            }
            
        }
        .onReceive(timer) { _ in
            self.updateTimer()
        }
    }
    
    private func nextTimer() {
        if isWorkTimer {
            isWorkTimer = false
            workCyclesCompleted += 1
            breakTimeRemaining = selectedBreakTime * 60 /// Utilizza il valore selezionato per la pausa
        } else {
            isWorkTimer = true
            workTimeRemaining = selectedWorkTime * 60 /// Utilizza il valore selezionato per il lavoro
            if workCyclesCompleted >= 4 {
                isActive = false
            }
        }
    }
    
    private func startTimer() {
        // Avvia il timer
        isActive = true
        isTimerStarted = true
        // Aggiorna i tempi rimanenti basandosi sui valori selezionati
        workTimeRemaining = selectedWorkTime * 60
        breakTimeRemaining = selectedBreakTime * 60
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
                showAlert = true
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
        if isWorkTimer {
            return Double(workTimeRemaining) / Double(selectedWorkTime * 60) // Calcola il progresso per il lavoro
        } else {
            return Double(breakTimeRemaining) / Double(selectedBreakTime * 60) // Calcola il progresso per la pausa
        }
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
