//
//  WeekDayToggle.swift
//  Stickies
//
//  Created by Ion Caus on 25.02.2023.
//

import SwiftUI

struct WeekDayToggle: View {
    @Binding var weekDay: WeekDay

    @State private var isOn = true

    var body: some View {
        ZStack {
            if weekDay.isOn {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.yellow.opacity(0.9))
            }
            
            Text(weekDay.name)
                .bold()
                
        }
        .onTapGesture {
            weekDay.isOn.toggle()
        }
        .frame(width: 40, height: 40, alignment: .center)
    }
}

struct WeekDayToggle_Previews: PreviewProvider {
    static var previews: some View {
        WeekDayToggle(weekDay: .constant(WeekDay(name: "M", id: 1)))
    }
}
