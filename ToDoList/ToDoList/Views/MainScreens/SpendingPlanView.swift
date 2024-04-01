import SwiftUI

struct SpendingPlanView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Divider()
                    Grid {
                        GridRow {
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
                    
                    List {
                        Section {
                            Text("Spesa")
                        }
                    }
                }
                .navigationTitle("Spending Plan")
            }
        }
    }
}

#Preview {
    SpendingPlanView()
}
