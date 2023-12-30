import SwiftUI

struct ToDoListItemView: View {
    
    @StateObject var viewModel = ListItemViewViewModel()
    let listItem: ToDoListItem
    @State var fontSize: Int
    @Binding var pomodoroIsClicked: Bool
    
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
            .onTapGesture { /// quando clicco sull'item NON MI APRE LA MODALE, isolando l'evento
                viewModel.toggleIsDone(item: listItem)
            }
            
            Spacer()
            
            if listItem.pomodoro {
                viewPomodoroButton()
            }
            
            // Checkbox
            Button {
                viewModel.toggleIsDone(item: listItem)
            } label: {
                Image(systemName: listItem.isDone ? "checkmark.circle.fill" : "circle")
            }
            .onTapGesture { /// quando clicco sull'item NON MI APRE LA MODALE, isolando l'evento
                viewModel.toggleIsDone(item: listItem)
            }
            .foregroundColor(Color.green)
        }
    }
    
    @ViewBuilder
    func viewPomodoroButton() -> some View {
        Button(action: {
            pomodoroIsClicked = true
        }, label: {
            ZStack {
                Rectangle()
                    .overlay(
                        LinearGradient(
                            stops: [
                                Gradient.Stop(color: Color(red: 0.94, green: 0.31, blue: 0.31), location: 0.00),
                                Gradient.Stop(color: Color(red: 1, green: 0.09, blue: 0.37), location: 1.00),
                            ],
                            startPoint: UnitPoint(x: 0.5, y: 0),
                            endPoint: UnitPoint(x: 0.5, y: 1)
                        )
                    )
                    .cornerRadius(10.0)
                    .frame(height: 50)
                
                Image(systemName: "timer")
                    .font(.system(size: 25))
                    .fontWeight(.medium)
                    .foregroundColor(Color.white)
            }
        })
        .simultaneousGesture(TapGesture().onEnded { /// previene il BUBBLING
            pomodoroIsClicked = true
        })
        .frame(width: 100 / 1.1)
        
        Spacer()
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
                pomodoro: true),
            
            fontSize: 25,
            pomodoroIsClicked: .constant(false)
        )
    }
}
