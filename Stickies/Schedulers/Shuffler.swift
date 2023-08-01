//
//  Shuffler.swift
//  Stickies
//
//  Created by Ion Caus on 01.08.2023.
//

import Foundation

class Shuffler : Scheduler {
    
    private let cards: [Card]
    
    private var iterator: Array<Card>.Iterator
    
    init(cards: [Card]) {
        self.cards = cards.shuffled()
        
        iterator = self.cards.makeIterator()
    }
    
    func getNextCard() -> Card? {
        iterator.next()
    }
    
    func answer(card: inout Card, with review: Review) {
        // nothing to update
    }
}
