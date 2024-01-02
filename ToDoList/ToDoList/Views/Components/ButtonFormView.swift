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
                    .fill(Theme.redGradient.gradient)
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
