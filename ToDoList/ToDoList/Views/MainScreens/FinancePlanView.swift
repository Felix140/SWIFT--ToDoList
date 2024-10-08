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
                            NavigationLink(destination: SpendingHistoryView(typeAmount: .add), label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 16.0)
                                        .fill(.ultraThinMaterial)
                                    
                                    VStack {
                                        Text("Total revenue")
                                        Text("\(formatNumber(viewModel.totalRevenue)) €")
                                            .bold()
                                            .font(.title)
                                        Image(systemName: "arrow.right")
                                    }
                                    .foregroundColor(.primary)
                                }
                            })
                            NavigationLink(destination: SpendingHistoryView(typeAmount: .subtract), label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 16.0)
                                        .fill(.ultraThinMaterial)
                                    
                                    VStack {
                                        Text("Total Spent")
                                        Text("\(formatNumber(viewModel.totalSpent)) €")
                                            .bold()
                                            .font(.title)
                                        Image(systemName: "arrow.right")
                                    }
                                    .foregroundColor(.primary)
                                }
                            })
                        }
                        .frame(height: 200)
                    }
                    .padding(.horizontal)
                    
                    
                    Grid {
                        GridRow {
                            NavigationLink(destination: SpendingHistoryView(typeAmount: .all), label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 16.0)
                                        .fill(.ultraThinMaterial)
                                    
                                    VStack {
                                        Text("Difference")
                                        Text("\(formatNumber(viewModel.totalAmount)) €")
                                            .bold()
                                            .font(.title)
                                        Image(systemName: "arrow.right")
                                    }
                                    .foregroundColor(.primary)
                                    .padding()
                                }
                            })
                        }
                        .frame(height: 200)
                    }
                    .padding(.horizontal)
                    
                    
                    
                    Divider()
                    
                    Section {
                        Button(action: {
                            viewModel.isPresentingView = true
                        }, label: {
                            HStack {
                                Image(systemName: "creditcard.fill")
                                Text("Edit")
                                    .padding(.leading, 10)
                            }
                        })
                        .frame(minWidth: 0, maxWidth: .infinity)
                    }
                    .padding()
                }
                .navigationTitle("\(Date().formatted(.dateTime.month().year()))")
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
                ModalSpendingItemView(viewModel: viewModel)
            }
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
    FinancePlanView()
}
