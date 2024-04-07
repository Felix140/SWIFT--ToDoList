import SwiftUI

struct FinancePlanView: View {
    
    @StateObject var viewModel = FinanceViewViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Divider()
                    
                    Grid {
                        GridRow {
                            Button(action: {}, label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 16.0)
                                        .fill(.ultraThinMaterial)
                                    
                                    VStack {
                                        Text("Total revenue")
                                        Text("\(formatNumber(viewModel.totalRevenue)) €")
                                            .bold()
                                            .font(.title)
                                    }
                                    .foregroundColor(.primary)
                                }
                            })
                            Button(action: {}, label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 16.0)
                                        .fill(.ultraThinMaterial)
                                    
                                    VStack {
                                        Text("Total Spent")
                                        Text("\(formatNumber(viewModel.totalSpent)) €")
                                            .bold()
                                            .font(.title)
                                    }
                                    .foregroundColor(.primary)
                                }
                            })
                        }
                        .frame(height: 200)
                    }
                    .padding(.horizontal)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 16.0)
                            .fill(.ultraThinMaterial)
                        
                        VStack {
                            Text("Difference")
                            Text("\(formatNumber(viewModel.difference)) €")
                                .bold()
                                .font(.title)
                        }
                        .foregroundColor(.primary)
                        .padding()
                    }
                    .frame(height: 200)
                    .padding(.horizontal)
                    
                    Divider()
                    
                    ButtonFormView(textBtn: "Edit", action: {
                        viewModel.isPresentingView = true
                    })
                    .padding()
                }
                .navigationTitle("Finance")
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button(action: {
                            // open analytics View
                        }) {
                            Image(systemName: "square.2.layers.3d.bottom.filled")
                        }
                        .accessibilityLabel("analytics")
                    }
                    
                    
                }
            }
        }
        .sheet(isPresented: $viewModel.isPresentingView) {
            NavigationStack {
                ModalSpendingItemView()
            }
        }
    }
    
    
    
    
    func formatNumber(_ number: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter.string(from: NSNumber(value: number)) ?? ""
    }
}

#Preview {
    FinancePlanView()
}
