//
//  Background.swift
//  Stickies
//
//  Created by Ion Caus on 03.07.2022.
//

import SwiftUI

struct Background: View {
    var body: some View {
        let colors: [Color] = [ Color(red: 0.09, green: 0.08, blue: 0.21), .blue]
            
        return Rectangle()
            .fill(AngularGradient(gradient: Gradient(colors: colors), center: .trailing))
            .edgesIgnoringSafeArea(.all)
    }
}

struct Background_Previews: PreviewProvider {
    static var previews: some View {
        Background()
    }
}
