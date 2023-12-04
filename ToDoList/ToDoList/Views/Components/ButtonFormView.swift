//
//  ButtonFormView.swift
//  ToDoList
//
//  Created by Felix Valdez on 04/12/23.
//

import SwiftUI

struct ButtonFormView: View {
    
    @State var textBtn: String
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            
            action()
            
        }, label: {
            ZStack {
                Rectangle()
                    .overlay(
                        LinearGradient(
                            stops: [
                                Gradient.Stop(color: Color(red: 0.96, green: 0.22, blue: 0.31), location: 0.00),
                                Gradient.Stop(color: Color(red: 1, green: 0.01, blue: 0.31), location: 1.00),
                            ],
                            startPoint: UnitPoint(x: 0.5, y: 0),
                            endPoint: UnitPoint(x: 0.5, y: 1)
                        )
                    )
                    .cornerRadius(15.0)
                    .frame(height: 50)
                
                Text(textBtn)
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
            }
        })
    }
}

struct ButtonFormView_Previews: PreviewProvider {
    
    static var previews: some View {
        ButtonFormView(textBtn: "Text Button", action: {})
            .previewLayout(.sizeThatFits)
    }
}
