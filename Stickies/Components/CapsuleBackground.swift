//
//  CapsuleBackground.swift
//  Stickies
//
//  Created by Ion Caus on 10.09.2023.
//

import SwiftUI

struct CapsuleBackground: ViewModifier {
    let textColor: Color
    let backgroundColor: Color
    let strokeColor: Color
    
    func body(content: Content) -> some View {
        content
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(strokeColor)
                    .offset(y: 3)
                
                RoundedRectangle(cornerRadius: 10)
                    .stroke(strokeColor, lineWidth: 1)
                    .background(backgroundColor.cornerRadius(10))
            }
            .foregroundColor(textColor)
            .padding([.horizontal, .top], 5)
            .padding(.bottom, 10)
    }
}
