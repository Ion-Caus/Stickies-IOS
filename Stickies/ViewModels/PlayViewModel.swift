//
//  PlayViewModel.swift
//  Stickies
//
//  Created by Ion Caus on 26.07.2022.
//

import Foundation
import CoreData

class PlayViewModel: ObservableObject {
    @Published var card: Card?
    
    private var cards: [Card]
    private let scheduler: Scheduler

    init(cards: [Card], shuffleMode: ShuffleMode) {
        self.cards = cards
        
        switch shuffleMode {
        case .random:
            scheduler = Shuffler(cards: cards)
        case .spacedRepetition:
            scheduler = SpacedRepetitionScheduler(cards: &self.cards)
        }
        
        card = scheduler.getNextCard()
    }
    
    func nextCard() {
        card = scheduler.getNextCard()
    }
    
    func updateCurrentCard(review: Review) {
        guard var card = card else { return }
        
        scheduler.answer(card: &card, with: review)
        
        let now = Date()
        card.modifiedDate = now
        
        let _ = CardEntry(
            card: card,
            createdDate: now,
            review: review,
            context: DataController.shared.context)
        
        DataController.shared.save()
    }
    
}
