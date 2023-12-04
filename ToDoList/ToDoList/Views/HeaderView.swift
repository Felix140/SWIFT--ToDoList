//
//  HeaderView.swift
//  ToDoList
//
//  Created by Felix Valdez on 04/12/23.
//

import SwiftUI

struct HeaderView: View {
    
    let title: String
    let subTitle: String
    let icon: String
    let angle: Double
    
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
                .rotationEffect(Angle(degrees: angle))
                .offset(y: -100)
            
            
            VStack {
                Text(title)
                    .font(.system(size: 40))
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                
                HStack {
                    Text(subTitle)
                        .foregroundColor(Color.white)
                    Image(systemName: icon)
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
        HeaderView(title: "Titolo",
                   subTitle: "SottoTitolo",
                   icon: "",
                   angle: 15)
            .previewLayout(.sizeThatFits)
    }
}
