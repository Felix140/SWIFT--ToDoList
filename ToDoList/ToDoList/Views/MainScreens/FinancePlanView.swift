import SwiftUI

struct FinancePlanView: View {
    
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
                                        .fill(.ultraThinMaterial)
                                    
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
                                        .fill(.ultraThinMaterial)
                                    
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
                        .frame(height: 200)
                    }
                    .padding(.horizontal)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 16.0)
                            .fill(.ultraThinMaterial)
                        
                        VStack {
                            Text("Difference")
                            Text("0€")
                                .bold()
                                .font(.title)
                        }
                        .foregroundStyle(.white)
                        .padding()
                    }
                    .frame(height: 200)
                    .padding(.horizontal)
                    
                    Divider()
                    
                    ButtonFormView(textBtn: "Edit", action: {
                        isPresentingView = true
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
        .sheet(isPresented: $isPresentingView) {
            NavigationStack {
                ModalSpendingItemView()
            }
        }
    }
}

#Preview {
    FinancePlanView()
}
