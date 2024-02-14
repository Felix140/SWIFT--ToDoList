import SwiftUI

struct ToDoListItemView: View {
    
    @StateObject var viewModel = ListItemViewViewModel()
    let listItem: ToDoListItem
    @State var fontSize: Int
    var haptic = HapticTrigger()
    
    var body: some View {
        HStack {
            Spacer()
                .frame(width: 10)
            
            // Checkbox
            Button {
                self.haptic.feedbackLight()
                viewModel.toggleIsDone(item: listItem)
            } label: {
                Image(systemName: listItem.isDone ? "checkmark.circle.fill" : "circle")
            }
            .foregroundColor(Color.green)
            
            Spacer()
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 4.0) {
                HStack {
                    // Categoria
                    if listItem.category != .none {
                        categoryTag()
                    }
                    // Descrizione Icona
                    if listItem.description.description != "" {
                        Image(systemName: "info.circle")
                            .font(.subheadline)
                            .foregroundColor(.green)
                    }
                }
                // Titolo
                Text(listItem.title)
                    .font(.system(size: CGFloat(fontSize)))
                
            }
            
            Spacer()
            
            Divider()
                .frame(height: 40)
            
            
            // Data + Ora
            dateAndTime()

        }
        .onTapGesture { /// quando clicco sull'item NON MI APRE LA MODALE, isolando l'evento
            viewModel.toggleIsDone(item: listItem)
        }
    }
    
    //MARK: - Category_Tag
    
    @ViewBuilder
    func categoryTag() -> some View {
        
        let categoryColor = themeColorForCategory(category: listItem.category)
        
        ZStack {
            RoundedRectangle(cornerRadius: 4.0)
                .fill(categoryColor)
                .frame(width: 90, height: 18)
            
            HStack {
                Text("#\(listItem.category.categoryName)")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.white)
                    .padding(.leading, 5)
                
                Spacer()
            }
            .frame(width: 90, height: 18)
        }
    }
    
    //MARK: - Date_and_time
    
    @ViewBuilder
    func dateAndTime() -> some View {
        VStack(alignment: .trailing) {
            Text("\(Date(timeIntervalSince1970: listItem.dueDate).formatted(.dateTime.day(.twoDigits).month()))")
                .font(.headline)
                .fontWeight(.medium)
                .foregroundColor(.accentColor)
            
            Text("\(Date(timeIntervalSince1970: listItem.dueDate).formatted(date: .omitted, time: .shortened))")
                .font(.footnote)
                .foregroundColor(Color(.secondaryLabel))
        }
        .padding(.horizontal)
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
                isDone: false,
                category: CategoryTask(rawValue: "Work") ?? .none,
                description: 
                    InfoToDoItem(
                        id: "IdUser",
                        description: "Lorem ipsum")),
            
            fontSize: 25
        )
        .previewLayout(.sizeThatFits)
    }
}
