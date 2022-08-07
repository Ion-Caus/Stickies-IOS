//
//  PlayViewModel.swift
//  Stickies
//
//  Created by Ion Caus on 26.07.2022.
//

import Foundation
import CoreData

class PlayViewModel: ObservableObject {
    @Published var cards: [Card]
    @Published var card: Card?
    
    private var iterator: Array<Card>.Iterator

    init(cards: [Card]) {
       
        let sortedCards = cards.isEmpty
            ? cards
            : cards.sorted(by: { $0.recallScore < $1.recallScore })
        
        self.cards = sortedCards
        
        iterator = sortedCards.makeIterator()
        card = iterator.next()
    }
    
    
    func nextCard() {
        card = iterator.next()
    }
    
    func updateCurrentCard(score: Int16) {
        guard let card = card else {
            return
        }
        
        card.recallScore += score
        card.modifiedDate = Date()
        
        DataController.shared.save()
    }
    
}
