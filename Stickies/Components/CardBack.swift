//
//  CardBack.swift
//  Stickies
//
//  Created by Ion Caus on 29.05.2022.
//

import SwiftUI

struct CardBack : View {
    let synonyms: [String]
    
    @Binding var degree : Double
    
    var body: some View {
        ZStack {
           RoundedRectangle(cornerRadius: 20)
               .fill(Color.blue.opacity(0.2))
    
               .shadow(color: .gray, radius: 2, x: 0, y: 0)

           RoundedRectangle(cornerRadius: 20)
               .fill(Color.blue.opacity(0.7))
               .padding()
           
           RoundedRectangle(cornerRadius: 20)
               .stroke(Color.blue.opacity(0.7), lineWidth: 3)
               .padding()
            
            VStack(alignment: .center) {
                GeometryReader { geometry in
                        ScrollView(.vertical) {
                            ScrollView(.vertical, showsIndicators: false){
                                ForEach(synonyms, id:\.self) { synonym in
                                    Text(synonym)
                                        .multilineTextAlignment(.center)
                                        .font(.title2)
                                        .padding(5)
                                }
                                .frame(width: geometry.size.width)      // Make the scroll view full-width
                                .frame(minHeight: geometry.size.height) // Set the content’s min height to the parent
                            }
            
                            
                        }
                    }
            }
            .padding()
           
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .rotation3DEffect(
            Angle(degrees: degree),
            axis: (x: 0, y: 1, z: 0.01))
        
    }
}

struct CardBack_Previews: PreviewProvider {
    static var previews: some View {
        CardBack(synonyms: ["some", "what u say?", "ok bro"], degree: .constant(0))
            .frame(width: 250, height: 350)
            .aspectRatio(3/4, contentMode: .fit)
            .padding()
            
    }
}

