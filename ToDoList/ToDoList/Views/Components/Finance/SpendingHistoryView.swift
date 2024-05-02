import SwiftUI

struct SpendingHistoryView: View {
    
    var typeAmount: SpendingTypology
    @StateObject var viewModel = HistoryFinanceViewViewModel()
    @State private var historyItems: [HistoryFinanceItem] = []
    
    var body: some View {
        NavigationView {
            List(historyItems) { item in
                HistoryItemView(amount: item.amount, typeAmount: typeAmount, description: item.descriptionText, spendingItemType: item.spendingType.rawValue)
            }
            .onAppear {
                viewModel.fetchHistoryItems(bySpendingType: typeAmount) { items in
                    self.historyItems = items
                }
            }
        }
        .navigationTitle("History: \(typeAmount.rawValue.capitalized)")
    }
}

#Preview {
    SpendingHistoryView(typeAmount: .add)
}

