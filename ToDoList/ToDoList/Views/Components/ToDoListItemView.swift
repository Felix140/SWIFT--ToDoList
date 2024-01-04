import SwiftUI

struct ToDoListItemView: View {
    
    @StateObject var viewModel = ListItemViewViewModel()
    let listItem: ToDoListItem
    @State var fontSize: Int
    @Binding var pomodoroIsClicked: Bool
    @Binding var descriptionIsClicked: Bool
    
    var body: some View {
        HStack {
            Spacer()
                .frame(width: 10)
            
            // Checkbox
            Button {
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
                            .fill(Color.secondary)
                            .frame(width: 90, height: 20)
                        
                        Text("#\(listItem.category.categoryName)")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(Color(.secondaryLabel))
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
            
            if listItem.pomodoro {
                viewPomodoroButton()
                    .simultaneousGesture(TapGesture().onEnded { /// previene il BUBBLING
                        pomodoroIsClicked = true
                    })
            }
            
            if listItem.description != "" {
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
    func viewPomodoroButton() -> some View {
        Button(action: {
            pomodoroIsClicked = true
        }, label: {
            ZStack {
                Circle()
                    .fill(Theme.redGradient.gradient)
                    .cornerRadius(100.0)
                    .frame(width: 40, height: 40)
                
                Image(systemName: "timer")
                    .font(.system(size: 18))
                    .fontWeight(.medium)
                    .foregroundColor(Color.white)
            }
        })
        .frame(width: 50 / 1.1)
        
        Spacer()
            .frame(width: 10)
    }
    
    
    @ViewBuilder
    func viewDescription() -> some View {
        Button(action: {
            descriptionIsClicked = true
        }, label: {
            ZStack {
                Circle()
                    .fill(Theme.redGradient.gradient)
                    .cornerRadius(100.0)
                    .frame(width: 40, height: 40)
                
                Image(systemName: "pencil.and.list.clipboard")
                    .font(.system(size: 18))
                    .fontWeight(.medium)
                    .foregroundColor(Color.white)
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
                pomodoro: true,
                category: CategoryTask(rawValue: "Work") ?? .none,
                description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur."),
            
            fontSize: 25,
            pomodoroIsClicked: .constant(false),
            descriptionIsClicked: .constant(false)
        )
    }
}
