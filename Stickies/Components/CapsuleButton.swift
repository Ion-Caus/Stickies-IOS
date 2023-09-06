//
//  CapsuleRectangle.swift
//  Stickies
//
//  Created by Ion Caus on 23.08.2023.
//

import SwiftUI

struct CapsuleButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    let backgroundColor: Color
    let strokeColor: Color
    let width: CGFloat?
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .background {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(strokeColor)
                        .offset(y: 3)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(strokeColor, lineWidth: 1)
                        .background {
                            isEnabled
                            ? backgroundColor.cornerRadius(10)
                            : Color.gray.cornerRadius(10)
                        }
                        .offset(y: configuration.isPressed ? 3 : 0)
                }
                .frame(width: width)
            }
            .padding([.horizontal, .top], 5)
            .padding(.bottom, 10)
           
           
    }
}

struct CapsuleButton: View {
    let text: String
    
    let textColor: Color
    let backgroundColor: Color
    let strokeColor: Color
    
    let width: CGFloat?
    
    let action: () -> Void
    
    init(text: String,
         textColor: Color,
         backgroundColor: Color,
         strokeColor: Color,
         width: CGFloat? = nil,
         action: @escaping () -> Void = { })
    {
        self.text = text
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.strokeColor = strokeColor
        self.width = width
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.headline)
                .foregroundColor(textColor)
                .padding()
        }
        .buttonStyle(CapsuleButtonStyle(backgroundColor: backgroundColor, strokeColor: strokeColor, width: width))
        
    }
}
struct CapsuleRectangle_Previews: PreviewProvider {
    static var previews: some View {
        CapsuleButton(
            text: "Test",
            textColor: .accentBlue,
            backgroundColor: .white,
            strokeColor: .darkGray)
    }
}
