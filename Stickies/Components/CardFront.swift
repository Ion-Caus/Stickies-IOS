//
//  CardFront.swift
//  Stickies
//
//  Created by Ion Caus on 29.05.2022.
//

import SwiftUI

struct CardFront : View {
    let type : String
    let word : String
    
    @Binding var degree : Double
    
    var body: some View {
        ZStack {
                       
           RoundedRectangle(cornerRadius: 20)
               .fill(Color.yellow.opacity(0.2))
               .shadow(color: .gray, radius: 2, x: 0, y: 0)
                

           RoundedRectangle(cornerRadius: 20)
               .fill(Color.yellow.opacity(0.7))
               .padding()
           
           RoundedRectangle(cornerRadius: 20)
               .stroke(Color.yellow.opacity(0.7), lineWidth: 3)
               .padding()
            
            VStack (alignment: .center) {
                Text(type)
                    .font(.subheadline)
                
                Text(word)
                    .font(.title)
                    .bold()
                    .padding(.bottom)
                
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .rotation3DEffect(
            Angle(degrees: degree),
            axis: (x: 0, y: 1, z: 0.01))
    }
}

struct CardFront_Previews: PreviewProvider {
    static var previews: some View {
        CardFront(type: "type", word: "word", degree: .constant(0))
            .padding()
    }
}
