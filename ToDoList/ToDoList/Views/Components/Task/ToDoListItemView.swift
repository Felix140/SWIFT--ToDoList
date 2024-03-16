import SwiftUI

struct ToDoListItemView: View {
    
    @StateObject var viewModel = ListItemViewViewModel()
    @State var fontSize: Int
    let listItem: ToDoListItem
    let imageButtonItem: Int
    var haptic = HapticTrigger()
    
    //MARK: - Body
    
    var body: some View {
        HStack {
            Spacer()
                .frame(width: 10)
            
            // Checkbox
            Button {
                self.haptic.feedbackLight()
                viewModel.toggleIsDone(item: listItem)
            } label: {
                    switch imageButtonItem {
                    case 0: Image(systemName: listItem.isDone ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(Color.clear)
                            .background(Theme.red.gradient)
                            .mask(Image(systemName: listItem.isDone ? "checkmark.circle.fill" : "circle"))
                    case 1: Image(systemName: listItem.isDone ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(.gray)
                    case 2: Image(systemName: "arrow.forward")
                            .foregroundColor(Color.clear)
                            .background(Theme.red.gradient)
                            .mask(Image(systemName: "arrow.forward"))
                    case 3: Image(systemName: "arrow.backward")
                            .foregroundColor(Color.clear)
                            .background(Theme.red.gradient)
                            .mask(Image(systemName: "arrow.backward"))
                    default: Image(systemName: listItem.isDone ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(Color.clear)
                            .background(Theme.red.gradient)
                            .mask(Image(systemName: listItem.isDone ? "checkmark.circle.fill" : "circle"))
                    }
            }

            
            Spacer()
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 4.0) {
                
                // CategoryTag
                if listItem.category != .none {
                    categoryTag()
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
            fontSize: 25,
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
            imageButtonItem: 0
            
        )
        .previewLayout(.sizeThatFits)
    }
}
