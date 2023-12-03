//
//  HeaderView.swift
//  ToDoList
//
//  Created by Felix Valdez on 04/12/23.
//

import SwiftUI

struct HeaderView: View {
    var body: some View {
        ZStack {
            
            RoundedRectangle(cornerRadius: 0)
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
                .rotationEffect(Angle(degrees: 15))
                .offset(y: -100)
            
            
            VStack {
                Text("To Do List")
                    .font(.system(size: 40))
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                
                HStack {
                    Text("Get Things DONE")
                        .foregroundColor(Color.white)
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(Color.white)
                }
            }
            .padding(.bottom, 80)
            
        }
        .frame(width: UIScreen.main.bounds.width * 3, height: 350)
        
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
            .previewLayout(.sizeThatFits)
    }
}
