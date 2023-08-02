//
//  Scheduler.swift
//  Stickies
//
//  Created by Ion Caus on 31.07.2023.
//

import Foundation

class SpacedRepetitionScheduler : Scheduler {
    
    //MARK: update algorithm and use these
    let intervalModifier = 1
    let hardInterval = 1.2
    let easyBonus = 1.3
    
    private let easeFactor: Double
    private let learningSteps: [Int]
    
    private let cards: [Card]
    
    private let newLimit = 20
    private let reviewLimit = 200
    private let learningLimit = 1000
    
    private var newQueue: [Card] = []
    private var learningQueue: [Card] = []
    private var reviewQueue: [Card] = []
    
    init(cards: inout [Card]) {
        self.cards = cards
        
        let easeFactor = UserDefaults.standard.double(forKey: AppStorageKeys.SpacedRepetitionEaseFactor)
        self.easeFactor = easeFactor != Double.zero ? easeFactor : Constants.DefaultEaseFactor
        
        self.learningSteps = UserDefaults.standard.array(forKey: AppStorageKeys.SpeechUtteranceRate) as? [Int]
                            ?? Constants.DefaultLearningSteps
    
        fillNewQueue()
        fillLearningQueue()
        fillReviewQueue()
        
          }
    
    private func fillNewQueue() {
        self.newQueue = cards
            .filter { $0.queueType == .New }
            .sorted(by: { $0.due < $1.due })
            .prefix(newLimit)
            .dropLast(0)
    }
    
    private func fillLearningQueue() {
        let cutOff = Date().addingTimeInterval( 1200 )
        self.learningQueue = cards
            .filter {
                $0.queueType == .Learning
                && $0.due < cutOff
            }
            .sorted(by: { $0.due < $1.due }) // change to creation date
            .prefix(learningLimit)
            .dropLast(0)
    }
    
    private func fillReviewQueue() {
        let endOfToday = Date().startOfNextDay
        self.reviewQueue = cards
            .filter {
                $0.queueType == .Review
                && $0.due < endOfToday
            }
            .sorted(by: { $0.due  < $1.due })
            .prefix(reviewLimit)
            .shuffled()
    }
    
    
    public func getNextCard() -> Card? {
        
        var card: Card?
        
        if !newQueue.isEmpty {
            if newQueue.isEmpty { fillNewQueue() }
            card = newQueue.removeFirst()
            if card != nil {
                return card
            }
        }
        
        // if empty refill
        if learningQueue.isEmpty { fillLearningQueue() }
        if !learningQueue.isEmpty {
            card = learningQueue.removeFirst()
            if card != nil {
                return card
            }
        }
        
        if !reviewQueue.isEmpty {
            if reviewQueue.isEmpty { fillReviewQueue() }
            card = reviewQueue.removeFirst()
            if card != nil {
                return card
            }
        }
        
        return nil
    }
    
    
    // return the card maybe, and save it in the db
    public func answer(card: inout Card, with review: Review) {
        
        switch card.queueType {
            
        case .New:
            return answerNew(card: &card, with: review)
        case .Learning:
            return answerLearning(card: &card, with: review)
        case .Review:
            return answerReview(card: &card, with: review)
        }
    }
    
    private func getLearningStep(at: Int) -> TimeInterval {
        TimeInterval(learningSteps[at])
    }
    
    private func answerNew(card: inout Card, with review: Review) {
        card.queueType = QueueType.Learning
        
        return answerLearning(card: &card, with: review)
    }
    
    private func answerLearning(card: inout Card, with review: Review) {
        
        var timeInterval = TimeInterval(card.interval)
        
        switch review {
        case .Again:
            timeInterval = getLearningStep(at: 0)
        case .Good:
            let index = learningSteps.firstIndex(of: Int(card.interval)) ?? 0
            if index >= learningSteps.count - 1 {
                // graduated
                card.queueType = .Review
            }
            else {
                timeInterval = getLearningStep(at: index+1)
            }
        }
        
        card.interval = Int64(timeInterval)
        card.due = Date.now.addingTimeInterval(timeInterval * 60)
    }
    
    private func answerReview(card: inout Card, with review: Review) {
        
        var timeInterval = TimeInterval(card.interval)
        
        switch review {
        case .Again:
            card.queueType = .Learning
            timeInterval = getLearningStep(at: 0)
        case .Good:
           
            timeInterval = timeInterval * easeFactor
        }
        print("\(card.interval) * \(easeFactor)")
        print(timeInterval)
        
        card.interval = Int64(timeInterval)
        card.due = Date.now.addingTimeInterval(timeInterval * 60)

    }

}
