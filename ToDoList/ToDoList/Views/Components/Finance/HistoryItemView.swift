import SwiftUI

struct HistoryItemView: View {
    
    @StateObject var viewModel = HistoryFinanceViewViewModel()
    @State var amount: Double
    @State var typeAmount: SpendingTypology
    @State var description: String
    @State var spendingItemType: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4.0) {
                categoryTag()
                // Descrizione
                Text(description)
                    .font(.title3)
            }
            Spacer()
            Divider()
                .frame(height: 40)
            // amount
            amountSpending()
        }
    }
    
    //MARK: - Amount
    
    @ViewBuilder
    func amountSpending() -> some View {
        VStack(alignment: .trailing) {
            HStack {
                switch typeAmount {
                case .add:
                    Image(systemName: "plus")
                case .subtract:
                    Image(systemName: "minus")
                default:
                    if spendingItemType == "earnings" {
                        Image(systemName: "plus")
                    } else {
                        Image(systemName: "minus")
                    }
                }
                Text("\(formatNumber(amount))€")
                    .font(.headline)
            }
            .foregroundColor(.accentColor)
            
            .fontWeight(.medium)
        }
        .padding(.horizontal)
    }
    
    //MARK: - Category_Tag
    
    @ViewBuilder
    func categoryTag() -> some View {
        let categoryColor = themeColorForCategory(category: .creativity)
        ZStack {
            RoundedRectangle(cornerRadius: 4.0)
                .fill(categoryColor)
                .frame(width: 90, height: 18)
            
            HStack {
                Text("#categoria")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.white)
                    .padding(.leading, 5)
                
                Spacer()
            }
            .frame(width: 90, height: 18)
        }
    }
    
    //MARK: - FormatNumber
    
    func formatNumber(_ number: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter.string(from: NSNumber(value: number)) ?? ""
    }
}

#Preview {
    HistoryItemView(
        amount: 100,
        typeAmount: .add,
        description: "Text",
        spendingItemType: "earnings")
}


//#Preview {
//    HistoryItemView(
//        historyItem: HistoryFinanceItem(
//            id: "1234",
//            amount: 100,
//            descriptionText: "DESCRIPTION",
//            spendingType: .add,
//            creationDate: TimeInterval(),
//            dateTask: TimeInterval(),
//            category: .entertainment,
//            status: .confirmed),
//        typeAmount: .add)
//}
