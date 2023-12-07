import SwiftUI

struct NewItemView: View {
    
    @StateObject var viewModel = NewItemViewViewModel()
    @Binding var toggleView: Bool
    
    var body: some View {
        VStack {
            Text("New Item")
                .font(.system(size: 30))
                .fontWeight(.bold)
                .padding(.top, 30)
            
            Form {
                TextField("Item title", text: $viewModel.title)
                
                DatePicker("Due date", selection: $viewModel.date)
                    .datePickerStyle(GraphicalDatePickerStyle())
            }
            .frame(height: 500)
            
            ButtonFormView(textBtn: "Save", action: {
                viewModel.save()
                toggleView = false
            })
            .padding([.trailing, .leading, .top], 30)
            
            Spacer()
        }
    }
}

struct NewItemView_Previews: PreviewProvider {
    static var previews: some View {
        NewItemView(toggleView: .constant(false))
    }
}
