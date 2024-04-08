import SwiftUI

struct SpendingHistoryView: View {
    var body: some View {
        NavigationView {
            VStack{
                ScrollView {
                    Section {
                        ForEach(0..<5, id: \.self) { _ in
                            
                            HistoryItemView()
                                .padding()
                            
                        }
                    }
                }
            }
            .navigationTitle("History")
        }
    }
}

#Preview {
    SpendingHistoryView()
}

