import SwiftUI

struct ToDoListItemView: View {
    
    let listItem: ToDoListItem
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                // Titolo
                Text(listItem.title)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                // Data
                Text("\(Date(timeIntervalSince1970: listItem.dueDate))")
                    .font(.footnote)
                    .foregroundColor(Color(.secondaryLabel))
            }
            
            Spacer()
            
            // Checkbox
            Button {
                
            } label: {
                Image(systemName: listItem.isDone ? "checkmark.circle.fill" : "circle")
            }
        }
    }
}

struct ToDoListItemView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoListItemView(listItem: .init(
            id: "123",
            title: "123",
            dueDate: 122312,
            createdDate: 123123,
            isDone: false))
    }
}
