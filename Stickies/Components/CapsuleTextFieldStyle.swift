//
//  CapsuleTextFieldStyle.swift
//  Stickies
//
//  Created by Ion Caus on 27.08.2023.
//

import SwiftUI

struct CapsuleTextFieldStyle: TextFieldStyle {
    let backgroundColor: Color
    let strokeColor: Color
    let textColor: Color


    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
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
