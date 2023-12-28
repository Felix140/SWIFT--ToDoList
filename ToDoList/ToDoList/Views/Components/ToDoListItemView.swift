import SwiftUI

struct ToDoListItemView: View {
    
    @StateObject var viewModel = ListItemViewViewModel()
    let listItem: ToDoListItem
    @State var fontSize: Int
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                // Titolo
                Text(listItem.title)
                    .font(.system(size: CGFloat(fontSize)))
                // Data + Ora
                Text("\(Date(timeIntervalSince1970: listItem.dueDate).formatted(date: .abbreviated, time: .shortened))")
                    .font(.footnote)
                    .foregroundColor(Color(.secondaryLabel))
            }
            
            Spacer()
            
            // Checkbox
            Button {
                viewModel.toggleIsDone(item: listItem)
            } label: {
                Image(systemName: listItem.isDone ? "checkmark.circle.fill" : "circle")
            }
            .foregroundColor(Color.green)
        }
    }
}

struct ToDoListItemView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoListItemView(
            listItem: .init(
            id: "IdUser",
            title: "Title",
            dueDate: 122312,
            createdDate: 123123,
            isDone: false), 
            fontSize: 25
        )
    }
}
