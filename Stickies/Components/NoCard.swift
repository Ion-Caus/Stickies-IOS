//
//  NoCard.swift
//  Stickies
//
//  Created by Ion Caus on 07.08.2022.
//

import SwiftUI

struct NoCard : View {

    var body: some View {
        ZStack {
                       
           RoundedRectangle(cornerRadius: 20)
               .fill(Color.gray.opacity(0.2))
               .shadow(color: .gray, radius: 2, x: 0, y: 0)
                

           RoundedRectangle(cornerRadius: 20)
               .fill(Color.gray.opacity(0.7))
               .padding()
           
           RoundedRectangle(cornerRadius: 20)
               .stroke(Color.gray.opacity(0.7), lineWidth: 3)
               .padding()
            
            Text("No Cards")
                .font(.title)
                .bold()
                .foregroundColor(Color.white)
                .padding(.bottom)
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)

    }
}


struct NoCard_Previews: PreviewProvider {
    static var previews: some View {
        NoCard()
    }
}
