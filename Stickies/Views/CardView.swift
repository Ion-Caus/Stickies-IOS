//
//  CardView.swift
//  Stickies
//
//  Created by Ion Caus on 13.08.2021.
//

import SwiftUI

struct CardView<MenuItems> : View where MenuItems : View {
    let card: Card
    
    let menuItems: () -> MenuItems
    
    @State var frontDegree: Double = 0.0
    @State var backDegree: Double = -90.0
    @State var isFlipped = false
    
    let durationAndDelay : Double = 0.2
    
    //MARK: Flip Card Function
    func flipCard () {
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
        ZStack {
            CardFront(type: card.type ?? "", word: card.word ?? "", degree: $frontDegree)
                .contextMenu(!isFlipped ? ContextMenu(menuItems: menuItems) : nil)
            CardBack(synonyms: card.synonyms  ?? [], degree: $backDegree)
        }
        .onTapGesture {
            flipCard()
        }
    }
}
