//
//  SecretTextField.swift
//  Stickies
//
//  Created by Ion Caus on 27.02.2023.
//

import SwiftUI

struct SecretTextField: View {
    
    var title: String
    
    @Binding var text: String
    
    @State private var isSecure: Bool = true
    
    init(_ title: String, text: Binding<String>) {
        self.title = title
        _text = text
    }
    
    var body: some View {
        HStack {
            Group {
                if isSecure {
                    SecureField(title, text: $text)
                }
                else {
                    TextField(title, text: $text)
                }
            }
            .animation(.easeInOut(duration: 0.2), value: isSecure)
          
            Button {
                isSecure.toggle()
            } label: {
                Image(systemName: !isSecure ? "eye.slash" : "eye" )
            }
        }
    }
}
