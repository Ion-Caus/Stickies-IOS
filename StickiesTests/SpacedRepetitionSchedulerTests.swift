//
//  StickiesTests.swift
//  StickiesTests
//
//  Created by Ion Caus on 02.08.2023.
//

import XCTest
import CoreData
@testable import Stickies

final class SpacedRepetitionSchedulerTests: XCTestCase {

    private var scheduler: SpacedRepetitionScheduler!
    
    private let context = TestCoreDataStack().persistentContainer.viewContext
    private var deck: Deck!
    
    override func setUp() {
        super.setUp()
        deck = Deck(title: "Test", type: DeckType.Synonym, language: "en", context: context)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    

    func testExample() throws {
        // Arrange
        var cards: [Card] = [
            Card(word: "", type: .Noun, isFavourite: true, synonyms: [], deck: deck, context: context),
            Card(word: "", type: .Noun, isFavourite: true, synonyms: [], deck: deck, context: context),
            
        ]
        
        scheduler = SpacedRepetitionScheduler(cards: &cards)
        
        // Act
        
        var card: Card?
        while true {
            card = scheduler.getNextCard()
            
            guard var card = card else { break }
            scheduler.answer(card: &card, with: .Good)
        }
        
        
        // Assert
        Swift.print(cards)
        
    }
}
