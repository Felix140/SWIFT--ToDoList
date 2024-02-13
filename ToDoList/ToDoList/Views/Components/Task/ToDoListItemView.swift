import SwiftUI

struct ToDoListItemView: View {
    
    @StateObject var viewModel = ListItemViewViewModel()
    let listItem: ToDoListItem
    @State var fontSize: Int
    @Binding var descriptionIsClicked: Bool
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
                // Categoria
                if listItem.category != .none {
                    categoryTag()
                }
                // Titolo
                Text(listItem.title)
                    .font(.system(size: CGFloat(fontSize)))
                
                // Description + Other info
//                if listItem.description.description != "" {
//                    viewDescription()
//                }
                
            }
            
            Spacer()
            
            Divider()
                .frame(height: 40)
            
            
            // Data + Ora
            VStack(alignment: .trailing) {
                Text("\(Date(timeIntervalSince1970: listItem.dueDate).formatted(.dateTime.day(.twoDigits).month()))")
                    .font(.headline)
                    .fontWeight(.regular)
                    .foregroundColor(.primary)
                
                Text("\(Date(timeIntervalSince1970: listItem.dueDate).formatted(date: .omitted, time: .shortened))")
                    .font(.footnote)
                    .foregroundColor(Color(.secondaryLabel))
            }
            .padding()
        }
        .onTapGesture { /// quando clicco sull'item NON MI APRE LA MODALE, isolando l'evento
            viewModel.toggleIsDone(item: listItem)
        }
    }
    
    
    
//    @ViewBuilder
//    func viewDescription() -> some View {
//        Button(action: {
////            self.haptic.feedbackLight()
////            descriptionIsClicked = true
//        }, label: {
//            ZStack {
//                RoundedRectangle(cornerRadius: 50.0)
//                    .fill(Color.blue)
//                    .frame(width: 90, height: 28)
//                
//                HStack {
//                    Text("Details")
//                        .font(.caption)
//                        .fontWeight(.semibold)
//                        .foregroundColor(Color.white)
//                        .padding(.leading, 5)
//                    
//                    Image(systemName: "info.circle.fill")
//                        .font(.caption)
//                        .fontWeight(.semibold)
//                        .foregroundColor(Color.white)
//                }
//                .frame(width: 90, height: 18)
//            }
//        })
//        .simultaneousGesture(TapGesture().onEnded { /// previene il BUBBLING
//            self.haptic.feedbackLight()
//            descriptionIsClicked = true
//        })
//    }
    
    
    @ViewBuilder
    func categoryTag() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4.0)
                .fill(Color.blue)
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
            
            fontSize: 25,
            descriptionIsClicked: .constant(false)
        )
    }
}
