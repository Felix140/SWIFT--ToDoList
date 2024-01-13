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
                // Titolo
                Text(listItem.title)
                    .font(.system(size: CGFloat(fontSize)))
                // Data + Ora
                Text("\(Date(timeIntervalSince1970: listItem.dueDate).formatted(date: .abbreviated, time: .shortened))")
                    .font(.footnote)
                    .foregroundColor(Color(.secondaryLabel))
            }
            
            Spacer()
            
            if listItem.description.description != "" {
                viewDescription()
                    .simultaneousGesture(TapGesture().onEnded { /// previene il BUBBLING
                        descriptionIsClicked = true
                    })
            }
            
        }
        .onTapGesture { /// quando clicco sull'item NON MI APRE LA MODALE, isolando l'evento
            viewModel.toggleIsDone(item: listItem)
        }
    }
    
    
    
    @ViewBuilder
    func viewDescription() -> some View {
        Button(action: {
            self.haptic.feedbackLight()
            descriptionIsClicked = true
        }, label: {
            ZStack {
                
                if #available(iOS 17.0, *) {
                    Circle()
                        .stroke(Theme.redGradient.gradient, lineWidth: 3)
                        .fill(Color.clear)
                        .cornerRadius(100.0)
                        .frame(width: 38)
                } else {
                    Circle()
                        .fill(Theme.redGradient.gradient)
                        .cornerRadius(100.0)
                        .frame(width: 38)
                }
                
                Image(systemName: "list.bullet")
                    .font(.system(size: 18))
                    .foregroundColor(Color.clear) // Make the original icon transparent
                    .background(Theme.redGradient.gradient) // Apply the gradient as background
                    .mask(Image(systemName: "list.bullet").font(.system(size: 18))) // gee=nerate a mask
            }
        })
        .frame(width: 50 / 1.1)
        .simultaneousGesture(TapGesture().onEnded { /// previene il BUBBLING
            descriptionIsClicked = true
        })
        
        Spacer()
            .frame(width: 10)
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
