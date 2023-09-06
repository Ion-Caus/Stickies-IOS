//
//  CapsulePicker.swift
//  Stickies
//
//  Created by Ion Caus on 04.09.2023.
//

import SwiftUI

struct CapsulePicker<T>: View where T : Hashable {
    let title: String
    @Binding var selection: T
    
    let collection: [T]
    let label: (T) -> String

    let backgroundColor: Color
    let strokeColor: Color
    
    var body: some View {
        Picker(title, selection: $selection) {
            ForEach(collection, id: \.self) { value in
                Text(label(value)).tag(value)
            }
        }
        .pickerStyle(.menu)
        .accentColor(strokeColor)
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(strokeColor)
                    .offset(y: 3)
                
                RoundedRectangle(cornerRadius: 10)
                    .stroke(strokeColor, lineWidth: 1)
                    .background(backgroundColor.cornerRadius(10))
        }
        .padding([.horizontal, .top], 5)
        .padding(.bottom, 10)
    }
}

struct CapsulePicker_Previews: PreviewProvider {
    static var previews: some View {
        CapsulePicker(title: "Type",
                      selection: .constant(WordType.Phrase),
                      collection: WordType.allCases,
                      label: { $0.rawValue },
                      backgroundColor: .accentWhite,
                      strokeColor: .darkGray)
    }
}
