//
//  Card+Extension.swift
//  Stickies
//
//  Created by Ion Caus on 16.07.2022.
//

import Foundation
import CoreData

extension Card {
    
    convenience init(word: String, type: WordType, isFavourite: Bool, synonyms: [String], usageExample: String? = nil,
                     phoneticTranscription: String? = nil, deck: Deck, context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = UUID()
        self.createdDate = Date()
        self.modifiedDate = Date()
        self.recallScore = 0
        
        self.word = word
        self.type = type.rawValue
        self.isFavourite = isFavourite
        self.synonyms = synonyms
        self.usageExample = usageExample
        self.phoneticTranscription = phoneticTranscription
        self.deck = deck
    }
    
    static func fetch() -> NSFetchRequest<Card> {
        let request: NSFetchRequest<Card> = Card.fetchRequest()
        request.sortDescriptors = [ NSSortDescriptor(keyPath: \Card.createdDate, ascending: false)]
        
        return request
    }
    
    static func fetchBy(deck: Deck) -> NSFetchRequest<Card> {
        let request: NSFetchRequest<Card> = Card.fetchRequest()
        request.sortDescriptors = [ NSSortDescriptor(keyPath: \Card.createdDate, ascending: false)]
        request.predicate = NSPredicate(format: "deck == %@", deck)

        return request
    }
    
    static func fetchWorst() -> NSFetchRequest<Card> {
        let request: NSFetchRequest<Card> = Card.fetchRequest()
        request.sortDescriptors = [ NSSortDescriptor(keyPath: \Card.recallScore, ascending: true)]
        request.fetchLimit = 20
        return request
    }
}

enum WordType: String, Equatable, CaseIterable {
    case Phrase = "Phrase"
    case Noun = "Noun"
    case Verb = "Verb"
    case Adjective = "Adjective"
    case Adverb = "Adverb"
    case Preposition = "Preposition"
    case Conjunction = "Conjunction"
    case Pronoun = "Pronoun"
    case Interjection = "Interjection"
}
