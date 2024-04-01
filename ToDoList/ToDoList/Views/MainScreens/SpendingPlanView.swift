import SwiftUI

struct SpendingPlanView: View {
    
    @State var isPresentingView = false
    
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
                                        .fill(Theme.redGradient.gradient)
                                    
                                    VStack {
                                        Text("Total revenue")
                                        Text("0€")
                                            .bold()
                                            .font(.title)
                                    }
                                    .foregroundStyle(.white)
                                }
                            })
                            Button(action: {}, label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 16.0)
                                        .fill(Theme.redGradient.gradient)
                                    
                                    VStack {
                                        Text("Total Spent")
                                        Text("0€")
                                            .bold()
                                            .font(.title)
                                    }
                                    .foregroundStyle(.white)
                                }
                            })
                        }
                        .frame(height: 100)
                    }
                    .padding(.horizontal)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 16.0)
                            .fill(Theme.redGradient.gradient)
                        
                        VStack {
                            Text("Difference")
                            Text("0€")
                                .bold()
                                .font(.title)
                        }
                        .foregroundStyle(.white)
                        .padding()
                    }
                    .frame(height: 100)
                    .padding(.horizontal)
                    
                    Divider()
                }
                .navigationTitle("Spending Plan")
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button(action: {
                            isPresentingView = true
                        }) {
                            Image(systemName: "bag.badge.plus")
                        }
                        .accessibilityLabel("Add new Item")
                    }
                }
            }
        }
        .sheet(isPresented: $isPresentingView) {
            NavigationStack {
                ModalSpendingItemView()
            }
        }
    }
}

#Preview {
    SpendingPlanView()
}
