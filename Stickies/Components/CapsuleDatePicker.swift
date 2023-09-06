//
//  CapsuleDatePicker.swift
//  Stickies
//
//  Created by Ion Caus on 06.09.2023.
//

import SwiftUI

struct CapsuleDatePicker: View {
    @Environment(\.colorScheme) private var colorScheme
    
    @Binding var date: Date
    
    var backgroundColor: Color {
        colorScheme == .dark ? .darkGray : .accentWhite
    }
    
    var strokeColor: Color {
        colorScheme == .dark ? .accentWhite : .darkGray
    }
    
    var body: some View {
        DatePicker("", selection: $date, displayedComponents: .hourAndMinute)
            .labelsHidden()
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

struct CapsuleDatePicker_Previews: PreviewProvider {    
    static var previews: some View {
        CapsuleDatePicker(date: .constant(Date()))
    }
}
