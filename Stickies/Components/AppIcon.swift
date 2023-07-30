//
//  AppIcon.swift
//  Stickies
//
//  Created by Ion Caus on 05.03.2023.
//

import SwiftUI

private struct CardIcon: View {
    let word: String
    let type: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .stroke(AppIcon.backgroundColor, lineWidth: 20)
                .padding()
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .padding()
            
            VStack(alignment: .center) {
                Text(type)
                    .font(.subheadline)
                
                Text(word)
                    .font(.largeTitle)
                    .bold()
            }
            .padding()
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .aspectRatio(3/4, contentMode: .fit)
        .frame(width: 300, height: 350)
        .foregroundColor(AppIcon.backgroundColor)
            
    }
}

struct AppIcon: View {
    static let appIconSize: CGFloat = 512
    static let backgroundColor = Color(red: 18/255, green: 98/255, blue: 172/255)
    
    var body: some View {
        ZStack {
            AppIcon.backgroundColor
            
            ZStack {
                
                CardIcon(word: "to  dare", type: "verb")
                     .rotationEffect(Angle(degrees: 0.0))
                     .offset(x: 70)
                     .scaleEffect(0.8)
                
                CardIcon(word: "Should I ?", type: "phrase")
                     .rotationEffect(Angle(degrees: 0.0))
                     .offset(x: -70, y: 30)
                     .scaleEffect(0.8)
            }
        }
        .frame(width: AppIcon.appIconSize, height: AppIcon.appIconSize)
    }
}

struct AppIcon_Previews: PreviewProvider {
    static var previews: some View {
        AppIcon()
            .previewLayout(
                .fixed(width: AppIcon.appIconSize,
                       height: AppIcon.appIconSize
                      )
            )
    }
}
