//
//  CardView.swift
//  Stickies
//
//  Created by Ion Caus on 13.08.2021.
//

import SwiftUI

struct CardView_Old : View  {
    let card: Card?
    
    @State var frontDegree: Double = 0.0
    @State var backDegree: Double = -90.0
    @State var isFlipped = false
    
    init(card: Card?) {
        self.card = card
    }
    
    let durationAndDelay : Double = 0.2
    
    //MARK: Flip Card Function
    func flipCard() {
        if !isFlipped {
            withAnimation(.linear(duration: durationAndDelay)) {
                frontDegree = 90
            }
            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)) {
                backDegree = 0
            }
        } else {
            withAnimation(.linear(duration: durationAndDelay)) {
                backDegree = -90
            }
            withAnimation(.linear(duration: Double(durationAndDelay)).delay(durationAndDelay)) {
                frontDegree = 0
            }
        }
        isFlipped.toggle()
    }
    
    var body: some View {
        if let card = card {
            ZStack {
                CardFront(type: card.type ?? "", word: card.word ?? "", isFavourite: card.isFavourite, degree: $frontDegree)
                    .opacity(backDegree == 0 ? 0  : 1)
                CardBack(synonyms: card.listOfSynonyms, degree: $backDegree)
                    .opacity(frontDegree == 0 ? 0 : 1)
            }
            .foregroundColor(.white)
            .onTapGesture {
                flipCard()
            }
        }
        else {
            NoCard()
                .opacity(0.5)
        }
    }
}
