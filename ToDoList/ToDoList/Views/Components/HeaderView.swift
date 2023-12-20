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
                            Gradient.Stop(color: Color(red: 0.94, green: 0.31, blue: 0.31), location: 0.00),
                            Gradient.Stop(color: Color(red: 1, green: 0.09, blue: 0.37), location: 1.00),
                        ],
                        startPoint: UnitPoint(x: 0.5, y: 0),
                        endPoint: UnitPoint(x: 0.5, y: 1)
                    )
                )
                .rotationEffect(Angle(degrees: angle))
            
            
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
            
        }
        .frame(width: UIScreen.main.bounds.width * 3, height: 400)
        
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(title: "Titolo",
                   subTitle: "SottoTitolo",
                   icon: "",
                   angle: 0)
        .previewLayout(.sizeThatFits)
    }
}
