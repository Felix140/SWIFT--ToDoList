import SwiftUI

struct ToDoListItemView: View {
    
    @StateObject var viewModel = ListItemViewViewModel()
    let listItem: ToDoListItem
    @State var fontSize: Int
    @Binding var pomodoroIsClicked: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4.0) {
                // Categoria
                Text("#\(listItem.category)")
                    .font(.subheadline)
                    .foregroundStyle(Color(.secondaryLabel))
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
            
            // Checkbox
            Button {
                viewModel.toggleIsDone(item: listItem)
            } label: {
                Image(systemName: listItem.isDone ? "checkmark.circle.fill" : "circle")
            }
            .foregroundColor(Color.green)
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
                    .frame(width: 50, height: 50)
                
                Image(systemName: "timer")
                    .font(.system(size: 25))
                    .fontWeight(.medium)
                    .foregroundColor(Color.white)
            }
        })
        .frame(width: 50 / 1.1)
        
        Spacer()
            .frame(width: 25)
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
                category: "Work"),
            
            fontSize: 25,
            pomodoroIsClicked: .constant(false)
        )
    }
}
