import SwiftUI

struct HistoryItemView: View {
    
    @StateObject var viewModel = HistoryFinanceViewViewModel()
    @State var amount: Double = 100.0
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4.0) {
                categoryTag()
                // Descrizione
                Text("Descrizione")
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
                Image(systemName: "plus")
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
    HistoryItemView()
}
