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

    init(cards: [Card], shuffleMode: ShuffleMode) {
        let today = Date()
        for card in cards {
            let cardDate = card.modifiedDate ?? Date()
            
            if cardDate == today { continue }
            
            let numberOfDays = Calendar.current.dateComponents([.day], from: cardDate, to: today)
                
            let deduction = Int16(Double(numberOfDays.day!) * 0.8)
            
            if (card.recallScore - deduction > 0) {
                card.recallScore -= deduction
            }
        }
        
        let shuffledCards = cards.shuffled() // randomize
        
        let preparedCards: [Card]
        switch shuffleMode {
            case .random:
                preparedCards = shuffledCards
            case .worstToBest:
                preparedCards = shuffledCards.sorted(by: { $0.recallScore < $1.recallScore })
            }
        
        self.cards = preparedCards
        iterator = preparedCards.makeIterator()
        card = iterator.next()
    }
    
    func nextCard() {
        card = iterator.next()
    }
    
    func updateCurrentCard(score: Int16) {
        guard let card = card else { return }
        
        let now = Date()
        card.recallScore += score
        card.modifiedDate = now
        
        if let cardId = card.id {
            let _ = CardEntry(
                cardId: cardId,
                createdDate: now,
                score: score,
                cardScore: card.recallScore,
                context: DataController.shared.context)
        }
        
        DataController.shared.save()
    }
    
}
